module ProfilePlus
  module HomeControllerMixin

    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    module InstanceMethods
      require "uuidtools"

      # will create profile with an user account
      def register_account
        profile = Profile.new(params[:profile])
        profile = update_profile_for_register_account(profile)
        if save_objeck(profile)
          if Notifier.trigger_register_thank_you(profile.id)
            profile.histories.create(:message => "Register Thank You email sent")
          end
          show_success(profile.class.to_s)
          set_session_user(profile.user)
        else
          profile = handle_profile_errors(profile)
          show_failure(profile)
        end
      end

      def request_password
        profile = Profile.find_by_email(params[:email])
        if profile.nil?
          flash[:error] = "Account not found."
          show_failure(nil)
        else
          if profile.user.nil?
            password = DateTime.now.to_s
            profile.build_user(
              :login => profile.email,
              :password => password,
              :password_confirmation => password
            )
          end
          profile.user.reset_token = UUIDTools::UUID.random_create.to_s
          profile.user.reset_requested_at = DateTime.now
          if profile.user.save
            if Notifier.trigger_send_request_password(profile.id, "#{request.protocol}#{request.host}/new-password?reset_token=#{profile.user.reset_token}")
              profile.histories.create(:message => "Request password email sent")
            end

            flash[:notice] = "Thank you. You will receive an e-mail shortly with a link to create a new password."
            show_success
          else # just in case
            flash[:error] = "Internal Error!"
            show_failure(nil)
          end
        end
      end

      def new_password
        if params[:user][:reset_token].empty_or_nil?
          flash[:error] = "Invalid request."
          show_failure(nil) and return
        end

        user = User.find_by_reset_token(params[:user][:reset_token])
        if user.nil? || user.reset_requested_at < Time.now - 1.day
          flash[:error] = "Request Expired."
          show_failure(nil) and return
        end

        # no need to update reset_token
        params[:user].delete(:reset_token)

        if params[:user][:password].empty_or_nil?
          user.errors.add(:password, "can't be blank")
          show_failure(user) and return
        end

        update_attributes(user, user.class.to_s)
        save_and_show(user, user.class.to_s)
      end

      # will lookup email then create a profile (without a user) if not found
      def marketing_sign_up
        if params[:profile][:email].empty_or_nil?
          flash[:newsletter_error] = "Email can't be blank."
          show_failure(nil) and return
        end

        if logged_in? && current_profile.email != params[:profile][:email]
          flash[:newsletter_error] = "Email entered does not match the email in your account."
          show_failure(nil) and return
        end
        profile = Profile.find_by_email(params[:profile][:email])

        if profile && profile.has_account? && !logged_in?
          flash[:newsletter_error] = "Email found. Login to manage your marketing preferences."
          show_failure(nil) and return
        end

        profile ||= Profile.new(params[:profile])
        profile = update_profile_for_marketing_sign_up(profile)
        if save_objeck(profile)
          Notifier.trigger_marketing_sign_up_thank_you(profile.id)
          show_success(profile.class.to_s)
          set_session_profile(profile) unless logged_in?
        else
          show_failure(profile)
        end
      end

      private

      def update_profile_for_register_account(profile)
        profile.build_user(
          :login => params[:profile][:login] || profile.email,
          :password => params[:profile][:password],
          :password_confirmation => params[:profile][:password_confirmation]
        )
        if profile.is_subscribed?
          profile.acquisition_source = "Website Newsletter"
        else
          profile.acquisition_source = "Site Registration"
        end
        if params[:profile][:address_postal_code]
          profile.address_label = params[:profile][:address_label].empty_or_nil? ? "Main Address" : params[:profile][:address_label]
          profile.address_first_name = params[:profile][:address_first_name].empty_or_nil? ? profile.first_name : params[:profile][:address_first_name]
          profile.address_last_name = params[:profile][:address_last_name].empty_or_nil? ? profile.last_name : params[:profile][:address_last_name]
          profile.addresses.build(
            :label => profile.address_label,
            :first_name => profile.address_first_name,
            :last_name => profile.address_last_name,
            :address_line_1 => params[:profile][:address_address_line_1],
            :address_line_2 => params[:profile][:address_address_line_2],
            :city => params[:profile][:address_city],
            :site_country_id => params[:profile][:address_site_country_id],
            :site_province_id => params[:profile][:address_site_province_id],
            :postal_code => params[:profile][:address_postal_code]
          )
        end
        profile
      end

      def handle_profile_errors(profile)
        profile.user.errors.each do |attribute, message|
          if params[:profile][attribute.to_sym].not_nil?
            profile.errors.add(attribute, message)
          end
        end
        if profile.addresses.length > 0
          # assume only one
          address = profile.addresses.first
          unless address.valid?
            address.errors.each do |attribute, message|
              address_attribute = "address_#{attribute.to_s}".to_sym
              if params[:profile][address_attribute].not_nil?
                profile.errors.add(address_attribute, message)
              end
            end
          end
        end
        profile
      end

      def update_profile_for_marketing_sign_up(profile)
        profile.is_subscribed = true

        if profile.new_record?
          profile.acquisition_source = "Website Newsletter"
          profile.first_name = profile.email unless params[:profile][:first_name]
          profile.last_name = "N/A" unless params[:profile][:last_name]
          profile.email_confirmation = profile.email
        else
          update_attributes(profile, profile.class.to_s)
        end
        profile
      end

    end

  end
end
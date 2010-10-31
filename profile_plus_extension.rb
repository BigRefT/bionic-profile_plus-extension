# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class ProfilePlusExtension < Bionic::Extension
  version "0.1"
  description "Adds enhanced capabilites to the user and profile models. (Forgot Password, Addresses, Phone, Email Marketing option)"
  url "http://www.bioniccms.com/extensions/profile_plus"

  require 'profile_plus/string_extensions'

  Site.send(:include, ProfilePlus::SiteMixin)
  Profile.send(:include, ProfilePlus::ProfileMixin)
  User.send(:include, ProfilePlus::UserMixin)
  Notifier.send(:include, ProfilePlus::NotifierMixin)
  UserDrop.send(:include, ProfilePlus::UserDropMixin)
  HomeController.send(:include, ProfilePlus::HomeControllerMixin)
  CustomerController.send(:include, ProfilePlus::CustomerControllerMixin)

  def activate
    admin_interface.navigation.user_management.add "Countries", "/admin/countries", :before => "Permissions"

    # insert views
    admin_interface.profile.edit.add(:form, "profile_plus", :after => "edit_last_name")
    admin_interface.profile.edit.add(:right_side, "addresses", :after => "profile_history")
    admin_interface.profile.new.add(:form, "profile_plus", :after => "edit_last_name")
    
    Bionic::AdminInterface.class_eval do
      attr_accessor :addresses
      attr_accessor :countries
    end
    admin_interface.addresses = load_default_addresses_regions
    admin_interface.countries = load_default_countries_regions

    Bionic::EmailSettings.instance.notifiers << { :name => "SendRequestPassword" }
    Bionic::EmailSettings.instance.notifiers << { :name => "RegisterThankYou" }
    Bionic::EmailSettings.instance.notifiers << { :name => "MarketingSignUpThankYou" }

    Bionic::FormForOptions.instance.custom_actions << {
      :form_action => "request_password",
      :model => nil,
      :new_url => "/forms/request_password",
      :edit_url => "/forms/request_password"
    }

    Bionic::FormForOptions.instance.custom_actions << {
      :form_action => "new_password",
      :model => 'user',
      :new_url => "/forms/new_password",
      :edit_url => "/forms/new_password"
    }

    Bionic::FormForOptions.instance.custom_actions << {
      :form_action => "marketing_sign_up",
      :model => 'profile',
      :new_url => "/forms/marketing_sign_up",
      :edit_url => "/forms/marketing_sign_up"
    }
    
    Bionic::FormForOptions.instance.custom_actions << {
      :form_action => "register_account",
      :model => 'profile',
      :new_url => "/forms/register_account",
      :edit_url => "/forms/register_account"
    }
  end

  def deactivate
  end

  def load_default_addresses_regions
    returning OpenStruct.new do |addresses|
      addresses.edit = Bionic::AdminInterface::RegionSet.new do |edit|
        edit.main.concat %w{edit_form}
        edit.form_top.concat %w{edit_errors}
        edit.form.concat %w{edit_first_name edit_last_name edit_label edit_address_1}
        edit.form.concat %w{edit_address_2 edit_country edit_province edit_city edit_postal_code}
        edit.form_bottom.concat %w{edit_buttons}
        edit.right_side.concat %w{}
      end
      addresses.new = addresses.edit
    end
  end

  def load_default_countries_regions
    returning OpenStruct.new do |countries|
      countries.index = Bionic::AdminInterface::RegionSet.new do |index|
        index.top.concat %w{}
        index.before_list.concat %w{}
        index.list_headers.concat %w{country_column_header}
        index.list_headers.concat %w{sub_regions_column_header actions_column_header}
        index.list_data.concat %w{country_column sub_regions_column actions_column}
        index.after_list.concat %w{pagination_links}
        index.action_row.concat %w{new_site_country}
        index.bottom.concat %w{}
        index.right_side.concat %w{}
      end
      countries.show = Bionic::AdminInterface::RegionSet.new do |show|
        show.above_content.concat %w{action_list}
        show.tab_header.concat %w{general_tab_header}
        show.tabs.concat %w{general_tab}

        show.general_list_content.concat %w{show_data show_form_header show_form}
        show.general_data.concat %w{}
        show.general_show_form_top.concat %w{}
        show.general_show_form.concat %w{show_form_column_headers show_form_buttons show_form_column_fields show_form_buttons}
        show.general_show_form_column_headers.concat %w{show_form_province_header show_form_active_header}
        show.general_show_form_column_fields.concat %w{show_form_province_field show_form_active_field}
        show.general_show_form_bottom.concat %w{}

        show.below_content.concat %w{tab_javascript}
        show.right_side.concat %w{}
      end
      countries.edit = Bionic::AdminInterface::RegionSet.new do |edit|
        edit.main.concat %w{edit_form}
        edit.form_top.concat %w{edit_errors}
        edit.form.concat %w{edit_country}
        edit.form_bottom.concat %w{edit_buttons}
        edit.right_side.concat %w{}
      end
      countries.new = countries.edit
    end
  end

end
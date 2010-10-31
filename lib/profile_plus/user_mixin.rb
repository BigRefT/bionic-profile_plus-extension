module ProfilePlus
  module UserMixin

    def self.included(base)
      base.class_eval do
        before_save :clear_reset_token_on_password_change
      end
    end

    private

    def clear_reset_token_on_password_change
      if self.crypted_password_changed? && !self.new_record?
        self.reset_token = nil
        self.reset_requested_at = nil
        self.profile.histories.create(:message => "New password created")
      end
    end

  end
end


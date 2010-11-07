module ProfilePlus
  module ProfileMixin

    def self.included(base)
      base.class_eval do
        const_set("ProfileTitles", { "Mrs." => "Mrs.", "Ms." => "Ms", "Mr." => "Mr." })

        # here to get fieldwithErrors around the combined sign up page
        attr_accessor :address_label, :address_first_name, :address_last_name,
                      :address_address_line_1, :address_address_line_2,
                      :address_city, :address_site_country_id, :address_site_province_id,
                      :address_postal_code

        has_many :addresses, :dependent => :destroy
        belongs_to :how_did_you_hear
        before_save :maybe_update_subcribed_date
        attr_accessible :phone, :evening_phone, :title, :is_subscribed, :company_name,
                        :how_did_you_hear_id, :how_did_you_hear_other,
                        :address_label, :address_first_name, :address_last_name,
                        :address_address_line_1, :address_address_line_2,
                        :address_city, :address_site_country_id, :address_site_province_id,
                        :address_postal_code

        validates_presence_of :how_did_you_hear_other, :if => :require_how_did_you_hear_other?
      end
    end

    private

    def maybe_update_subcribed_date
      ensure_acquisition_source if self.new_record?
      if self.is_subscribed_changed?
        self.subscribed_updated_at = Time.now
        message = self.is_subscribed? ? "Subscribed to email marketing." : "Unsubscribed from email marketing."
        self.histories.build(:message => message)
      end
    end

    def ensure_acquisition_source
      self.acquisition_source ||= "Other"
      # only add the created history if none exist
      if self.histories.length == 0
        self.histories.build(:message => "Profile Created: #{self.acquisition_source}")
      end
    end

    def require_how_did_you_hear_other?
      self.how_did_you_hear && self.how_did_you_hear.other?
    end

  end
end

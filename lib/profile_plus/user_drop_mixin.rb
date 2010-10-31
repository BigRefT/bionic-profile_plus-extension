module ProfilePlus
  module UserDropMixin

    def phone
      profile_attribute :phone
    end

    def evening_phone
      profile_attribute :evening_phone
    end

    def title
      profile_attribute :title
    end

    def addresses
      return [] if user.nil? && profile.nil?
      profile.addresses.map { |address| AddressDrop.new(address) }
    end

    def is_subscribed?
      return nil if user.nil? && profile.nil?
      return profile.is_subscribed?
    end

    def how_did_you_hear
      return nil if user.nil? && profile.nil?
      return profile.how_did_you_hear
    end

    def company_name
      return nil if user.nil? && profile.nil?
      return profile.company_name
    end

    def available_titles
      rvalue = []
      Profile::ProfileTitles.each do |title, value|
        rvalue << value
      end
      rvalue
    end

  end
end
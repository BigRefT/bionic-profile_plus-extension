module ProfilePlus
  module SiteMixin

    def self.included(base)
      base.class_eval do
        has_many :site_countries
        has_many :countries, :through => :site_countries

        has_many :site_provinces
        has_many :provinces, :through => :site_provinces
      end
    end

  end
end

class SiteProvince < ActiveRecord::Base
  belongs_to :site
  belongs_to :province
  belongs_to :site_country

  acts_as_audited :protect => false
  acts_as_site_member

  attr_accessible :province_id, :active

  named_scope :active, :conditions => { :active => true }

  class << self
    def find_id_by_name_or_code(name_or_code, site_country_id = nil)
      site_province = find_by_name_or_code(name_or_code, site_country_id)
      site_province ? site_province.id : nil
    end

    def find_by_name_or_code(name_or_code, site_country_id = nil)
      province = find_by_code(name_or_code, site_country_id)
      province ||= find_by_name(name_or_code, site_country_id)
      province
    end

    def find_by_code(code, site_country_id = nil)
      conditions = ["provinces.code = ?", code]
      if site_country_id
        conditions[0] += " AND site_country_id = ?"
        conditions << site_country_id
      end
      SiteProvince.find(:first, :conditions => conditions, :joins => :province)
    end

    def find_by_name(name, site_country_id = nil)
      conditions = ["lower(provinces.name) = lower(?) OR lower(provinces.name) LIKE lower(?)", name, "%#{name}%"]
      if site_country_id
        conditions[0] += " AND site_country_id = ?"
        conditions << site_country_id
      end
      SiteProvince.find(:first, :conditions => conditions, :joins => :province)
    end
  end

  def audit_url
    "dashboard_admin_url"
  end

  def auditable_name
    "#{self.province.name}"
  end

  def name
    self.province.name
  end

  def code
    self.province.code
  end

end

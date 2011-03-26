class SiteCountry < ActiveRecord::Base
  belongs_to :site
  belongs_to :country
  has_many :site_provinces, :dependent => :destroy

  acts_as_audited :protect => false
  acts_as_site_member

  attr_accessible :country_id  
  validates_presence_of :country_id
  before_create :build_provinces

  class << self
    def find_id_by_code(code)
      site_country = SiteCountry.find(:first, :conditions => ["countries.code = ?", code], :joins => :country)
      site_country ? site_country.id : nil
    end

    def find_by_code(code)
      SiteCountry.find(:first, :conditions => ["countries.code = ?", code], :joins => :country)
    end
  end

  def audit_url
    "dashboard_admin_url"
  end
  
  def auditable_name
    "#{self.country.name}"
  end
  
  def name
    self.country.name
  end
  
  def code
    self.country.code
  end
  
  private
  
  def build_provinces
    self.country.provinces.each do |province|
      self.site_provinces.build(:province_id => province.id, :tax => 0.00)
    end
  end
  
end

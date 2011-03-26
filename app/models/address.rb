class Address < ActiveRecord::Base
  belongs_to :profile
  belongs_to :site_country
  belongs_to :site_province

  acts_as_site_member
  acts_as_audited :protect => false

  attr_accessible :first_name, :last_name, :label,
                  :address_line_1, :address_line_2,
                  :city, :postal_code,
                  :site_country_id, :site_province_id

  validates_presence_of :first_name, :last_name, :label,
                        :address_line_1, :city, :postal_code,
                        :site_country_id, :site_province_id

  validates_uniqueness_of :label, :scope => [:profile_id, :site_id]

  class << self

    def form_for_find(id, profile_id)
      Address.find(:first, :conditions => ["id = ? and profile_id = ?", id, profile_id])
    end

  end

  def audit_url
    if self.profile
      ['edit', 'admin', self.profile, self]
    else
      nil
    end
  end

  def auditable_name
    if self.profile
      "#{self.profile.email}: #{self.label}"
    else
      "#{self.label}"
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def province_code
    return nil if self.site_province.nil?
    self.site_province.province.code
  end

  def province_name
    return nil if self.site_province.nil?
    self.site_province.province.name
  end

  def country_code
    return nil if self.site_country.nil?
    self.site_country.country.code
  end

  def country_name
    return nil if self.site_country.nil?
    self.site_country.country.name
  end

  def country
    self.site_country.country rescue nil
  end

  protected

  def validate
    unless  self.postal_code.empty_or_nil?
      self.postal_code.strip!
      self.postal_code.upcase!
      unless self.country.postal_code_validation.empty_or_nil?
        errors.add(:postal_code, " is invalid") unless self.postal_code =~ Regexp.new(self.country.postal_code_validation)
      end
    end
  end

end

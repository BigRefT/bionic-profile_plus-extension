class Country < ActiveRecord::Base
  has_many :provinces, :dependent => :destroy
  has_many :site_countries, :dependent => :destroy
  has_many :sites, :through => :site_countries
end

class Province < ActiveRecord::Base
  belongs_to :country
  has_many :site_provinces, :dependent => :destroy
  has_many :sites, :through => :site_provinces
end

class AddAustraliaAsCountry < ActiveRecord::Migration
  def self.up
    country = Country.create(:name => "Australia", :code => "AU", :province_title => "States & Territories")
    Province.create(:name => "New South Wales", :code => "NSW", :country_id => country.id)
    Province.create(:name => "Queensland", :code => "QLD", :country_id => country.id)
    Province.create(:name => "South Australia", :code => "SA", :country_id => country.id)
    Province.create(:name => "Tasmania", :code => "TAS", :country_id => country.id)
    Province.create(:name => "Victoria", :code => "VIC", :country_id => country.id)
    Province.create(:name => "Western Australia", :code => "WA", :country_id => country.id)
    Province.create(:name => "Australian Capital Territory", :code => "ACT", :country_id => country.id)
    Province.create(:name => "Northern Territory", :code => "NT", :country_id => country.id)
  end

  def self.down
    country = Country.find_by_name("Australia")
    country.destroy
  end
end

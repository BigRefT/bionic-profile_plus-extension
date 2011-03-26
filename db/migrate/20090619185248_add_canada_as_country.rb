class AddCanadaAsCountry < ActiveRecord::Migration
  def self.up
    country = Country.create(
      :name => "Canada",
      :code => "CA",
      :province_title => "Provinces",
      :postal_code_validation => '\A([a-zA-Z]\d[a-zA-Z])[\s-]?(\d[a-zA-Z]\d)\z'
    )
    Province.create(:name => "Ontario", :code => "ON", :country_id => country.id)
    Province.create(:name => "Quebec", :code => "QC", :country_id => country.id)
    Province.create(:name => "Nova Scotia", :code => "NS", :country_id => country.id)
    Province.create(:name => "New Brunswick", :code => "NB", :country_id => country.id)
    Province.create(:name => "Manitoba", :code => "MB", :country_id => country.id)
    Province.create(:name => "British Columbia", :code => "BC", :country_id => country.id)
    Province.create(:name => "Prince Edward Island", :code => "PE", :country_id => country.id)
    Province.create(:name => "Saskatchewan", :code => "SK", :country_id => country.id)
    Province.create(:name => "Alberta", :code => "AB", :country_id => country.id)
    Province.create(:name => "Newfoundland and Labrador", :code => "NL", :country_id => country.id)
    Province.create(:name => "Northwest Territories", :code => "NT", :country_id => country.id)
    Province.create(:name => "Yukon", :code => "YT", :country_id => country.id)
    Province.create(:name => "Nunavut", :code => "NU", :country_id => country.id)
  end

  def self.down
    country = Country.find_by_name("Canada")
    country.destroy
  end
end

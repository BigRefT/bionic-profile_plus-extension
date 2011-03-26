class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      t.string :name
      t.string :code
      t.integer :country_id
      t.timestamps
    end

    add_index :provinces, :country_id

    Province.create(:name => "Alabama", :code => "AL", :country_id => 1)
    Province.create(:name => "Alaska", :code => "AK", :country_id => 1)
    Province.create(:name => "American Samoa", :code => "AS", :country_id => 1)
    Province.create(:name => "Arizona", :code => "AZ", :country_id => 1)
    Province.create(:name => "Arkansas", :code => "AR", :country_id => 1)
    Province.create(:name => "California", :code => "CA", :country_id => 1)
    Province.create(:name => "Colorado", :code => "CO", :country_id => 1)
    Province.create(:name => "Connecticut", :code => "CT", :country_id => 1)
    Province.create(:name => "Delaware", :code => "DE", :country_id => 1)
    Province.create(:name => "District of Columbia", :code => "DC", :country_id => 1)
    Province.create(:name => "Federated States of Micronesia", :code => "FM", :country_id => 1)
    Province.create(:name => "Florida", :code => "FL", :country_id => 1)
    Province.create(:name => "Georgia", :code => "GA", :country_id => 1)
    Province.create(:name => "Guam", :code => "GU", :country_id => 1)
    Province.create(:name => "Hawaii", :code => "HI", :country_id => 1)
    Province.create(:name => "Idaho", :code => "ID", :country_id => 1)
    Province.create(:name => "Illinois", :code => "IL", :country_id => 1)
    Province.create(:name => "Indiana", :code => "IN", :country_id => 1)
    Province.create(:name => "Iowa", :code => "IA", :country_id => 1)
    Province.create(:name => "Kansas", :code => "KS", :country_id => 1)
    Province.create(:name => "Kentucky", :code => "KY", :country_id => 1)
    Province.create(:name => "Louisiana", :code => "LA", :country_id => 1)
    Province.create(:name => "Maine", :code => "ME", :country_id => 1)
    Province.create(:name => "Marshall Islands", :code => "MH", :country_id => 1)
    Province.create(:name => "Maryland", :code => "MD", :country_id => 1)
    Province.create(:name => "Massachusetts", :code => "MA", :country_id => 1)
    Province.create(:name => "Michigan", :code => "MI", :country_id => 1)
    Province.create(:name => "Minnesota", :code => "MN", :country_id => 1)
    Province.create(:name => "Mississippi", :code => "MS", :country_id => 1)
    Province.create(:name => "Missouri", :code => "MO", :country_id => 1)
    Province.create(:name => "Montana", :code => "MT", :country_id => 1)
    Province.create(:name => "Nebraska", :code => "NE", :country_id => 1)
    Province.create(:name => "Nevada", :code => "NV", :country_id => 1)
    Province.create(:name => "New Hampshire", :code => "NH", :country_id => 1)
    Province.create(:name => "New Jersey", :code => "NJ", :country_id => 1)
    Province.create(:name => "New Mexico", :code => "NM", :country_id => 1)
    Province.create(:name => "New York", :code => "NY", :country_id => 1)
    Province.create(:name => "North Carolina", :code => "NC", :country_id => 1)
    Province.create(:name => "North Dakota", :code => "ND", :country_id => 1)
    Province.create(:name => "Northern Mariana Islands", :code => "MP", :country_id => 1)
    Province.create(:name => "Ohio", :code => "OH", :country_id => 1)
    Province.create(:name => "Oklahoma", :code => "OK", :country_id => 1)
    Province.create(:name => "Oregon", :code => "OR", :country_id => 1)
    Province.create(:name => "Palau", :code => "PW", :country_id => 1)
    Province.create(:name => "Pennsylvania", :code => "PA", :country_id => 1)
    Province.create(:name => "Puerto Rico", :code => "PR", :country_id => 1)
    Province.create(:name => "Rhode Island", :code => "RI", :country_id => 1)
    Province.create(:name => "South Carolina", :code => "SC", :country_id => 1)
    Province.create(:name => "South Dakota", :code => "SD", :country_id => 1)
    Province.create(:name => "Tennessee", :code => "TN", :country_id => 1)
    Province.create(:name => "Texas", :code => "TX", :country_id => 1)
    Province.create(:name => "Utah", :code => "UT", :country_id => 1)
    Province.create(:name => "Vermont", :code => "VT", :country_id => 1)
    Province.create(:name => "Virgin Islands", :code => "VI", :country_id => 1)
    Province.create(:name => "Virginia", :code => "VA", :country_id => 1)
    Province.create(:name => "Washington", :code => "WA", :country_id => 1)
    Province.create(:name => "West Virginia", :code => "WV", :country_id => 1)
    Province.create(:name => "Wisconsin", :code => "WI", :country_id => 1)
    Province.create(:name => "Wyoming", :code => "WY", :country_id => 1)
    Province.create(:name => "Armed Forces", :code => "AE", :country_id => 1)
    Province.create(:name => "Armed Forces Americas", :code => "AA", :country_id => 1)
    Province.create(:name => "Armed Forces Pacific", :code => "AP", :country_id => 1)

  end

  def self.down
    drop_table :provinces
  end
end

class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.string :province_title
      t.string :postal_code_validation
      t.timestamps
    end

    Country.create(
      :name => "United States",
      :code => "US",
      :province_title => "States",
      :postal_code_validation => '\A\d{5}(-\d{4})?\z'
    )
  end

  def self.down
    drop_table :countries
  end
end

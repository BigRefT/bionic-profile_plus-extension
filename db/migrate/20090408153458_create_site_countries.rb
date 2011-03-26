class CreateSiteCountries < ActiveRecord::Migration
  def self.up
    create_table :site_countries do |t|
      t.integer :country_id
      t.integer :site_id
      t.timestamps
    end

    add_index :site_countries, :site_id
    add_index :site_countries, :country_id
    add_index :site_countries, [:country_id, :site_id]
  end

  def self.down
    drop_table :site_countries
  end
end

class CreateSiteProvinces < ActiveRecord::Migration
  def self.up
    create_table :site_provinces do |t|
      t.integer :province_id
      t.boolean :active, :default => true
      t.integer :site_country_id
      t.integer :site_id
      t.timestamps
    end

    add_index :site_provinces, :site_id
    add_index :site_provinces, :site_country_id
    add_index :site_provinces, :province_id
    add_index :site_provinces, :active
    add_index :site_provinces, [:site_country_id, :site_id]
    add_index :site_provinces, [:province_id, :site_id]
    add_index :site_provinces, [:active, :site_id]
  end

  def self.down
    drop_table :site_provinces
  end
end

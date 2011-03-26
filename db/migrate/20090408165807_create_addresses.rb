class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :first_name, :last_name, :label
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.integer :site_province_id
      t.string :postal_code
      t.integer :site_country_id
      t.integer :profile_id
      t.integer :site_id
      t.timestamps
    end

    add_index :addresses, :site_id
    add_index :addresses, :profile_id
    add_index :addresses, :site_country_id
    add_index :addresses, :site_province_id
    add_index :addresses, [:profile_id, :site_id]
  end

  def self.down
    drop_table :addresses
  end
end

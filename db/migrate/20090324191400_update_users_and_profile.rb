class UpdateUsersAndProfile < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_token, :string
    add_column :users, :reset_requested_at, :datetime
    
    add_column :profiles, :title, :string
    add_column :profiles, :phone, :string
    add_column :profiles, :evening_phone, :string
    add_column :profiles, :is_subscribed, :boolean, :default => false
    add_column :profiles, :subscribed_updated_at, :datetime
    add_column :profiles, :acquisition_source, :string
    add_column :profiles, :how_did_you_hear_id, :integer
    add_column :profiles, :how_did_you_hear_other, :string
    add_column :profiles, :company_name, :string

    add_index :profiles, :how_did_you_hear_id
  end

  def self.down
    remove_column :users, :reset_token
    remove_column :users, :reset_requested_at
    
    remove_column :profiles, :title
    remove_column :profiles, :phone
    remove_column :profiles, :evening_phone
    remove_column :profiles, :is_subscribed
    remove_column :profiles, :subscribed_updated_at
    remove_column :profiles, :acquisition_source
    remove_column :profiles, :how_did_you_hear_id
    remove_column :profiles, :how_did_you_hear_other
    remove_column :profiles, :company_name

    remove_index :profiles, :how_did_you_hear_id
  end
end

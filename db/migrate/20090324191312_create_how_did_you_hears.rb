class CreateHowDidYouHears < ActiveRecord::Migration
  def self.up
    create_table :how_did_you_hears do |t|
      t.string :label
      t.boolean :other, :default => false
      t.boolean :active, :default => true
      t.integer :position
      t.integer :site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :how_did_you_hears
  end
end

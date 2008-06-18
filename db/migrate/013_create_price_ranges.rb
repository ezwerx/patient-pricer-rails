class CreatePriceRanges < ActiveRecord::Migration
  def self.up
    create_table :price_ranges do |t|
      t.column :position,     :integer, :null => false
      t.column :low,          :float, :null => false
      t.column :high,         :float, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end  end

  def self.down
    drop_table :price_ranges
  end
end

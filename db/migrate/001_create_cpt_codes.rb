class CreateCptCodes < ActiveRecord::Migration
  def self.up
    create_table :cpt_codes do |t|
      t.column :code,         :integer, :null => false
      t.column :description,  :text, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end
  end

  def self.down
    drop_table :cpt_codes
  end
end

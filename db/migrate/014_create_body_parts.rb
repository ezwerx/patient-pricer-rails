class CreateBodyParts < ActiveRecord::Migration
  def self.up

    create_table :body_parts do |t|
      t.column :name,         :string, :limit => 20, :null => false
      t.column :category,     :string, :limit => 20, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end  end

  def self.down
    drop_table :body_parts
  end
end

class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
        t.column :text, :string, :limit => 20, :null => false
    end
  end

  def self.down
    drop_table :words
  end
end

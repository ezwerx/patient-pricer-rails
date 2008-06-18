class AllowNullSvcDesc < ActiveRecord::Migration
  def self.up
    change_column :services, :description, :text, :null => true
  end

  def self.down
    change_column :services, :description, :text, :null => false
  end
end

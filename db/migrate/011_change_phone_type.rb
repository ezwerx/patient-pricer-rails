class ChangePhoneType < ActiveRecord::Migration
  def self.up
    change_column :providers, :phone, :string, :limit => 14, :null => false
  end

  def self.down
    change_column :providers, :phone, :integer, :limit => 10, :null => false
  end
end

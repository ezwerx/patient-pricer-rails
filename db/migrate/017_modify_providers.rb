class ModifyProviders < ActiveRecord::Migration
  def self.up
    change_column :providers, :name,         :string,  :limit => 50, :null => false
    change_column :providers, :address1,     :string,  :limit => 50, :null => false
    change_column :providers, :address2,     :string,  :limit => 50
    change_column :providers, :city,         :string,  :limit => 50, :null => false
    change_column :providers, :email,        :string,  :limit => 50
    change_column :providers, :contact,      :string,  :limit => 50
  end

  def self.down
    change_column :providers, :name,         :string,  :limit => 40, :null => false
    change_column :providers, :address1,     :string,  :limit => 40, :null => false
    change_column :providers, :address2,     :string,  :limit => 40
    change_column :providers, :city,         :string,  :limit => 40, :null => false
    change_column :providers, :email,        :string,  :limit => 40
    change_column :providers, :contact,      :string,  :limit => 40
  end
end

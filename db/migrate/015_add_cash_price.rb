class AddCashPrice < ActiveRecord::Migration
  def self.up
    add_column :provider_services, :cash_price, :decimal, :precision => 8, :scale => 2, :default => 0, :null => false
    rename_column :provider_services, :price, :list_price
  end

  def self.down
    remove_column :provider_services, :cash_price
  end
end

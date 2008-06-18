class AllowNullCashPrice < ActiveRecord::Migration
  def self.up
    change_column :provider_services, :cash_price, :decimal, :precision => 8, :scale => 2, :default => nil, :null => true
  end

  def self.down
    change_column :provider_services, :cash_price, :decimal, :precision => 8, :scale => 2, :default => 0, :null => false
  end
end

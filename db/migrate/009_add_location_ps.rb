class AddLocationPs < ActiveRecord::Migration
  def self.up
    add_column :provider_services, :latitude, :float
    add_column :provider_services, :longitude, :float
  end

  def self.down
    remove_column :provider_services, :latitude
    remove_column :provider_services, :longitude
  end
end

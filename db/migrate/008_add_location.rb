class AddLocation < ActiveRecord::Migration
  def self.up
    add_column :providers, :latitude, :float
    add_column :providers, :longitude, :float
  end

  def self.down
    remove_column :providers, :latitude
    remove_column :providers, :longitude
  end
end

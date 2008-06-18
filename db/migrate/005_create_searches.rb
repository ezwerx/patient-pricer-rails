class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
    end
  end

  def self.down
    drop_table :searches
  end
end

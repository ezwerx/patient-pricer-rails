class CreateSponsoredLinks < ActiveRecord::Migration
  def self.up
    create_table :sponsored_links do |t|
      t.column :title,        :string,  :limit => 40, :null => false
      t.column :description,  :text,    :null => false
      t.column :url,          :text,    :null => false
      t.column :domain_name,  :string,  :limit => 40, :null => false
    end
  end

  def self.down
    drop_table :sponsored_links
  end
end

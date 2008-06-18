class CreateProviders < ActiveRecord::Migration
  
  def self.up
    create_table :providers do |t|
        t.column :name,         :string,  :limit => 40, :null => false
        t.column :address1,     :string,  :limit => 40, :null => false
        t.column :address2,     :string,  :limit => 40
        t.column :city,         :string,  :limit => 40, :null => false
        t.column :state,        :string,  :limit => 2,  :null => false
        t.column :zip,          :string,  :limit => 9,  :null => false
        t.column :phone,        :integer, :limit => 10, :null => false
        t.column :email,        :string,  :limit => 40
        t.column :contact,      :string,  :limit => 40
        t.column :url,          :string,  :limit => 256
        t.column :lock_version, :integer, :default => 0
        t.column :created_at,   :datetime
        t.column :updated_at,   :datetime
    end
    
  end

  def self.down
    drop_table :providers
  end
end

class CreateAmenities < ActiveRecord::Migration
  def self.up
    create_table :amenities do |t|
      t.column :name,         :string,  :limit => 40, :null => false
      t.column :description,  :text,    :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end
    create_table :provider_amenities do |t|      
      t.column :provider_id,  :integer, :null => false
      t.column :amenity_id,   :integer, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end
  
    execute "alter table provider_amenities
             add constraint fk_provider_amenity_providers
             foreign key (provider_id) references providers(id)"        

    execute "alter table provider_amenities
             add constraint fk_provider_smenity_amenities
             foreign key (amenity_id) references amenities(id)"        
    
  end

  def self.down
    drop_table :provider_amenities
    drop_table :amenities
  end
end

class CreateProviderServices < ActiveRecord::Migration
  
  def self.up
    create_table :provider_services do |t|
      t.column :provider_id,  :integer, :null => false
      t.column :service_id,   :integer, :null => false
      t.column :price,        :decimal, :precision => 8, :scale => 2, :default => 0, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end
    
    execute "alter table provider_services
             add constraint fk_provider_service_providers
             foreign key (provider_id) references providers(id)"        

    execute "alter table provider_services
             add constraint fk_provider_service_services
             foreign key (service_id) references services(id)"        
  end

  def self.down
    drop_table :provider_services
  end
end

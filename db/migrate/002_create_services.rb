class CreateServices < ActiveRecord::Migration
  
  def self.up
    create_table :services do |t|
      t.column :name,         :string,  :limit => 40, :null => false
      t.column :description,  :text,    :null => false
      t.column :cpt_code_id,  :integer
      t.column :lock_version, :integer, :default => 0
      t.column :created_at,   :datetime
      t.column :updated_at,   :datetime
    end
    
    execute "alter table services
             add constraint pp2_fk_service_cpt_codes
             foreign key (cpt_code_id) references cpt_codes(id)"
  end

  def self.down
    drop_table :services
  end
end

class ServiceDescriptor < ActiveRecord::Base
  
  belongs_to :service
  belongs_to :descriptor
  
  validates_presence_of :service_id, :descriptor_id
    
end

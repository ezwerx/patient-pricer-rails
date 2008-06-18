class Amenity < ActiveRecord::Base

  has_many :provider_amenities, :dependent => :destroy
  has_many :providers, :through => :provider_amenities  

  validates_presence_of :name, :description
  
end

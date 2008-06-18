class Provider < ActiveRecord::Base

  #acts_as_ferret
  
  has_many :provider_services, :dependent => :destroy
  has_many :services, :through => :provider_services
  
  has_many :provider_amenities, :dependent => :destroy
  has_many :amenities, :through => :provider_amenities
  
  validates_presence_of :name, :address1, :city, :state, :zip, :phone, :latitude, :longitude
  validates_numericality_of :zip, :latitude, :longitude
  
end

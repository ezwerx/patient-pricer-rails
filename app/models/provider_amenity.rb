class ProviderAmenity < ActiveRecord::Base

  belongs_to :provider
  belongs_to :amenity

  validates_uniqueness_of :amenity_id, :scope => :provider_id
  validates_presence_of :provider_id
  validates_presence_of :amenity_id

end

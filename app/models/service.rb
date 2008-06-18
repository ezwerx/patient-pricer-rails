class Service < ActiveRecord::Base

  acts_as_ferret(:fields => [:name])
  
  attr_accessor :test
  
  has_many :provider_services, :dependent => :destroy
  has_many :providers, :through => :provider_services  
  
  validates_presence_of :name

  belongs_to :cpt_code
  
  def cpt_plus_name
    cpt_code.code.to_s + "-" + name
  end

end

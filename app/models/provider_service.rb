class ProviderService < ActiveRecord::Base
  
#  acts_as_ferret(:additional_fields => {:latitude => {:store => :yes,:boost => 1}, :longitude => {:store => :yes,:boost => 1}, :service_name => {:boost => 2}, :service_description => {:boost => 1}, :service_cpt_code_id => {:boost => 1}, :provider_name => {:boost => 1}, :provider_city => {:boost => 1}, :provider_state => {:boost => 1}, :provider_zip => {:boost => 1}})
#  acts_as_ferret(:additional_fields => { :list_price => {:store => :yes,:boost => 1}, :latitude => {:store => :yes,:boost => 1}, :longitude => {:store => :yes,:boost => 1}, :service_name => {:boost => 2}, :service_description => {:boost => 1}, :service_cpt_code_id => {:boost => 1}, :provider_name => {:boost => 1}, :amenity_ids => {:store => :yes,:boost => 1}})
  acts_as_ferret(:fields => { :list_price => {:store => :yes,:boost => 1}, :latitude => {:store => :yes,:boost => 1}, :longitude => {:store => :yes,:boost => 1}, :service_name => {:boost => 2}, :service_description => {:boost => 1}, :service_cpt_code_id => {:boost => 1}, :provider_name => {:boost => 1}, :amenity_ids => {:store => :yes,:boost => 1}},
                  :default_field => { :list_price => {:store => :yes,:boost => 1}, :latitude => {:store => :yes,:boost => 1}, :longitude => {:store => :yes,:boost => 1}, :service_name => {:boost => 2}, :service_description => {:boost => 1}, :service_cpt_code_id => {:boost => 1}, :provider_name => {:boost => 1}, :amenity_ids => {:store => :yes,:boost => 1}},
                  :ferret => { :analyzer => Ferret::Analysis::StandardAnalyzer.new([]) }
  )
  
  attr_accessor :latitude
  attr_accessor :longitude
  
  belongs_to :provider
  belongs_to :service
  
  validates_uniqueness_of :service_id, :scope => :provider_id
  validates_presence_of :provider_id
  validates_presence_of :service_id
  #validates_presence_of :list_price
  validates_numericality_of :list_price, :allow_nil => true
  #validates_format_of :list_price, :with => /^\$?\d{1,3}(\,?\d{3})*(\.\d{2})?$/

  def self.make_distance_proc(ulatitude, ulongitude, ulimit, uamenity_ids, ulow, uhigh)
    Proc.new do |doc_id, score, searcher|
      
      row_is_a_match = true
      
      provider_service_id = searcher[doc_id][:id]
      #logger.warn(">>>>provider_service_id = " + provider_service_id.to_s)

      if (row_is_a_match)
        if ( (ulow != nil) && (uhigh != nil) && (ulow >= 0) && (uhigh > ulow) ) 
          #if user has specified price criteria
          #logger.warn(">>>>>>>ulow = " + ulow.to_s)
          #logger.warn(">>>>>>>uhigh = " + ulow.to_s)
          ps_price = searcher[doc_id][:list_price].to_f
          if ( (ps_price < ulow) || (ps_price > uhigh) )  
            row_is_a_match = false
          end
        end
      end

      #logger.warn(">>>>>>>after price filter: " + row_is_a_match.to_s)

      if (row_is_a_match)
        if ( (uamenity_ids != nil) && (uamenity_ids != "") )
          #if user has specified amenity criteria        
          user_amenity_ids = uamenity_ids.split(",")
          ps_amenity_ids = searcher[doc_id][:amenity_ids].split(",")
          amenity_intersection = user_amenity_ids & ps_amenity_ids
          if (amenity_intersection != user_amenity_ids)
            row_is_a_match = false
          end
        end
      end

      #logger.warn(">>>>>>>after amenity filter: " + row_is_a_match.to_s)

      if (row_is_a_match)
        if (ulimit != nil)
          #if user has specified distance criteria
          ps_latitude = searcher[doc_id][:latitude].to_f
          ps_longitude = searcher[doc_id][:longitude].to_f
          distance = SearchUtility.calculate_distance(ulatitude, ulongitude, ps_latitude, ps_longitude)
          if (ulimit < distance)
            row_is_a_match = false            
          end
        end
      end

      #logger.warn(">>>>>>>after location filter: " + row_is_a_match.to_s)

      next row_is_a_match
    end
  end
  
  def get_distance(ulatitude, ulongitude)
    SearchUtility.calculate_distance(ulatitude, ulongitude, latitude.to_f, longitude.to_f)
  end
  
  def rank
    ferret_rank
  end
  
  def score
    (ferret_score * 100000).round/1000.0
  end
  
  def service_name
    service.name    
  end
  
  def service_description
    service.description    
  end
  
  def service_cpt_code_id
    service.cpt_code_id    
  end
  
  def provider_name
    provider.name
  end
  
  def provider_city
    provider.city
  end
  
  def provider_state
    provider.state
  end
  
  def provider_zip
    provider.zip
  end
  
  def latitude
    provider.latitude
  end
  
  def longitude
    provider.longitude
  end
  
  def amenity_ids
    provider.amenities.collect { |amenity| amenity.id }.join ','
  end

end

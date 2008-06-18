class Search < NoTable
  
    column :text,               :string
    column :page_size,          :integer
    column :distance,           :integer
    column :user_latitude,      :float
    column :user_longitude,     :float
    column :starting_location,  :string
    column :amenity_ids_s,      :string
    column :price_range_id,     :integer
    
    def amenity_ids
      if (@amenity_ids_s == nil) || (@amenity_ids_s == "") then
        []
      else
        @amenity_ids_s.split(",")
      end
    end
    def amenity_ids=(new_amenity_ids)
      @amenity_ids_s = new_amenity_ids.join(",")
    end
        
    validates_presence_of :text
    
    def validate
      logger.warn 'user_latitude= ' + user_latitude.to_f.to_s
      logger.warn 'user_longitude= ' + user_longitude.to_f.to_s
      if (is_numeric(:user_latitude, :starting_location, 'is not a complete US postal address'))
        is_numeric :user_longitude, :starting_location, 'is not a complete US postal address'
      end
    end
    
    def is_numeric(attr_to_check,attr_to_mark,message)
      begin
        Kernel.Float(send("#{attr_to_check}_before_type_cast").to_s)
        return true
      rescue ArgumentError, TypeError
        errors.add(attr_to_mark, message)
        return false
      end
    end
    
end

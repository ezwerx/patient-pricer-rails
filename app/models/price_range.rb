class PriceRange < ActiveRecord::Base
  
  acts_as_list
  validates_presence_of :low
  validates_presence_of :high
  
  def validate
    if (low != nil && high != nil)
      if (low >= high)
        errors.add(:low, "must be less than High")
      end
    end
  end
  
  def to_s
    sprintf("$%0.2f",low) + " to " + sprintf("$%0.2f",high)
  end
  
end

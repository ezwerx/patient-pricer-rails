# calculator.rb
# June 25, 2007
#

class SearchUtility
  
  def initialize
  end
  
  def self.calculate_distance(latitude1,longitude1,latitude2,longitude2)

    #############################################################
    # The Haversine formula according to Dr. Math.
    # http://mathforum.org/library/drmath/view/51879.html
    #
    # dlon = lon2 - lon1
    # dlat = lat2 - lat1
    # a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
    # c = 2 * atan2(sqrt(a), sqrt(1-a)) 
    # d = R * c
    #
    # Where
    #   * dlon is the change in longitude
    #   * dlat is the change in latitude
    #   * c is the great circle distance in Radians.
    #   * R is the radius of a spherical Earth.
    #   * The locations of the two points in 
    #     spherical coordinates (longitude and 
    #     latitude) are lon1,lat1 and lon2, lat2.
    #############################################################

    pi = 3.141592654
    #dDistance = Double.MinValue
    dLat1InRad = latitude1 * (pi / 180.0)
    dLong1InRad = longitude1 * (pi / 180.0)
    dLat2InRad = latitude2 * (pi / 180.0)
    dLong2InRad = longitude2 * (pi / 180.0)

    dLongitude = dLong2InRad - dLong1InRad;
    dLatitude = dLat2InRad - dLat1InRad;

    # Intermediate result a.
    a = (Math.sin(dLatitude / 2.0) ** 2.0) + 
        Math.cos(dLat1InRad) * Math.cos(dLat2InRad) * 
        (Math.sin(dLongitude / 2.0) ** 2.0)

    # Intermediate result c (great circle distance in Radians).
    c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0 - a))

    # Distance.
    kEarthRadius = 3956.0 #Miles
    #kEarthRadius = 6376.5 # Kilometers
    dDistance = ((kEarthRadius * c) * 10).round/10.0

    return dDistance;    
  end
  
  def self.expand_search_text(user_search_text)
    
    expanded_search_text = user_search_text
    search_temp = user_search_text
    search_words = []

    dStart = search_temp.index(/[^a-zA-Z0-9\-]/)
    while dStart != nil && dStart >= 0
      dEnd = search_temp.index(/[a-zA-Z0-9\-]/,dStart)
      if dEnd != nil && dEnd > dStart
        #first word is a search term
        search_word = search_temp[0..dStart-1].to_s
        search_words << search_word
        #second word is the delimiter
        search_word = search_temp[dStart..dEnd-1].to_s
        search_words << search_word
        #remove what we just processed
        search_temp = search_temp[dEnd..search_temp.length].to_s
        dStart = search_temp.index(/[ |;|-]/) rescue -1
      else
        break
      end
    end
    if search_temp > ''
        search_words << search_temp
    end

    0.upto(search_words.length - 1) do |i|
      search_word = search_words[i]
      if (search_word.upcase == 'OR') || (search_word.upcase == 'AND') || (search_word.upcase == 'NOT')
        search_word = search_word.upcase
        search_words[i] = search_word
      elsif (search_word > '')
        expanded_search_words = []
        word = Word.find_by_text(search_word)
        search_word = search_word + '*' unless search_word[search_word.length-1,1].index(/[a-zA-Z0-9]/) == nil
        if (word == nil) #word does not exist in our dictionary
          search_words[i] = search_word
        else
          expanded_search_words << search_word
          for child_word in word.child_words
            search_word = child_word.text
            search_word = search_word + '*' unless search_word[search_word.length-1,1].index(/[a-zA-Z0-9]/) == nil
            expanded_search_words << search_word
          end
          search_word = '(' + expanded_search_words.join('||') + ')'
          search_words[i] = search_word
        end
      end
      expanded_search_text = search_words.join()
    end
    
    return expanded_search_text
  end

  def self.get_coordinates(location)

    result = []

    if location == nil || location == ''
      return result
    end
    
    address = URI.encode(location)
    uri = 'rpc.geocoder.us'
    path = ['/service/csv?address=',address].to_s
    
    begin
      resp = Net::HTTP.get_response(uri,path) # get_response takes an URI object
      data = resp.body
      tokens = data.split(',')
      result << tokens[0] unless tokens.length < 1
      result << tokens[1] unless tokens.length < 2
    rescue
      logger.warn 'Error= ' + $!
      result = []
    end

    return result
  
  end
  
end



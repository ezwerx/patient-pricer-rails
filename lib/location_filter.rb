class LocationFilter < Ferret::Search::Filter
  include Ferret

  def initialize(search_lat, search_long, radius)
    @search_lat = search_lat
    @search_long = search_long
    @radius = radius
  end

  def bits(reader)
    # This BitVector will determine which documents are
    # possible results for queries using this filter.
    bits = Utils::BitVector.new()

    search_lat = deg2rad(@search_lat)
    search_long = deg2rad(@search_long)

    docs = reader.term_docs()
    while term_docs.next?
      show_doc = reader.get_document(docs.doc)

      # Get the latitude and longitude for the show
      show_lat = show_doc["latitude"]
      show_long = show_doc["longitude"]

      show_lat = deg2rad(show_lat)
      show_long = deg2rad(show_long)

      # Use the spherical law of cosines to determine
      # the distance between the show's location
      # and the user's location.
      x = (Math.sin(show_lat) * Math.sin(search_lat)) +
           (Math.cos(show_lat) * Math.cos(search_lat) *
            Math.cos(show_long - search_long))

      if x == 1.0
        # The coordinates are the same
        distance = 0
      else
        distance = Math.acos(x) * EARTH_RADIUS_IN_MILES
      end

      bits.set(docs.doc) if distance <= @radius
    end

    return bits
  end
end

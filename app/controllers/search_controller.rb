require 'net/http'

class SearchController < ApplicationController
  
  #auto_complete_for :search, :text
  
  protect_from_forgery :except => [:auto_complete_for_search_text]
  
  def auto_complete_for_search_text
    search_text = params[:search][:text]
    #if (search_text.length > 2)
      #search_text = SearchUtility.expand_search_text(search_text)
      #logger.warn(['search_text: ',search_text])
      @services = Service.find_by_contents(search_text, {:sort => :name, :lazy => false, :limit => 18})
    #else
    #  @services = []
    #end
    render :partial => 'services'
  end
  
  def initialize
    @distances = [5,10,15,20,25,30,40,50,60,70,80,90,100,500]
  end

  def index
    #ProviderService.rebuild_index
    @search = Search.new()
    @search.distance = 500
    @search.text = ''
    @search.starting_location = params[:search][:starting_location] rescue ''
    @search.starting_location = '2299 Post Street, San Francisco, CA 94115' unless @search.starting_location != ''
    render :action => 'find'
  end
  
  def find
    #ProviderService.rebuild_index
    @search = Search.new()
    @search.distance = 500
    @search.text = ''
    @search.starting_location = params[:search][:starting_location] rescue ''
    @search.starting_location = '2299 Post Street, San Francisco, CA 94115' unless @search.starting_location != ''
  end
  
  def list
    @amenities = Amenity.find(:all, :order => :name)
    @price_ranges = PriceRange.find(:all, :order => :position )
    params[:page_size] = 10 unless params[:page_size]
    if (params[:page] == nil || params[:page] == "")
      location =SearchUtility.get_coordinates(params[:search][:starting_location])
      #logger.warn 'starting_location= ' + location.join(',')
      session[:user_latitude] = location[0] rescue nil
      session[:user_longitude] = location[1] rescue nil
      params[:page] = 1 unless params[:page]
      @current_search_text_expanded = ""
      @search = Search.new(params[:search])
      @search.user_latitude = session[:user_latitude]
      @search.user_longitude = session[:user_longitude]
      if (@search.valid?)
        if (@search.price_range_id != nil)
          @price_range = PriceRange.find(@search.price_range_id)
        end
        if (@price_range == nil)
          @price_range = PriceRange.new
        end
        @current_search_text_expanded = SearchUtility.expand_search_text(@search.text)
        #logger.warn(['@current_search_text_expanded: ',@current_search_text_expanded])
        session[:current_search_text] = @search.text
        session[:current_search_text_expanded] = @current_search_text_expanded
        session[:current_search_distance] = @search.distance
        find_options = {:include => [:provider,:service]}
        sort = :list_price
        #sort = "ferret_score desc"
        search_amenity_ids = @search.amenity_ids.join(",") rescue ""
        filter_proc = 
          ProviderService.make_distance_proc(
            session[:user_latitude].to_f, 
            session[:user_longitude].to_f, 
            @search.distance.to_i, 
            search_amenity_ids, 
            @price_range.low, 
            @price_range.high)
        @provider_services = ProviderService.paginating_ferret_search({:sort => sort, :q => @current_search_text_expanded, :filter_proc => filter_proc, :page_size => params[:page_size].to_i, :current => params[:page] }, find_options)
      else
        #render :action => 'find'
      end
    else
      params[:page] = 1 unless params[:page]
      @search = Search.new()
      @search.text = session[:current_search_text].to_s
      @search.distance = session[:current_search_distance]
      @search.user_latitude = session[:user_latitude]
      @search.user_longitude = session[:user_longitude]
      if (@search.price_range_id != nil)
        @price_range = PriceRange.find(@search.price_range_id)
      end
      if (@price_range == nil)
        @price_range = PriceRange.new
      end
      @current_search_text_expanded = session[:current_search_text_expanded]
      find_options = {:include => [:provider,:service]}
      sort = :list_price
      #sort = "ferret_score desc"
      search_amenity_ids = @search.amenity_ids.join(",") rescue ""
      filter_proc = ProviderService.make_distance_proc(session[:user_latitude].to_f, session[:user_longitude].to_f, @search.distance.to_i, search_amenity_ids, @price_range.low, @price_range.high)
      @provider_services = ProviderService.paginating_ferret_search({:sort => sort, :q => @current_search_text_expanded, :filter_proc => filter_proc, :page_size => params[:page_size].to_i, :current => params[:page] }, find_options)
    end
    @sponsored_links = SponsoredLink.find(:all)

    render(:layout => 'search_results')
    
  end
  
end

class ProvidersController < ApplicationController

  layout "main"
 
  def initialize()
    @states = ['CA','VT','WI']
    $active_tab = 'providers'
    $custom_stylesheet1 = ''
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@provider_pages, @providers = paginate :providers, :per_page => 15, :order => 'name'
    @providers = Provider.find(:all, :order => :name, :page => {:size => 20, :current => params[:page], :first => 1})
  end

  def show
    $custom_stylesheet1 = 'providers/show.css'
    @provider = Provider.find(params[:id])
  end

  def new
    $custom_stylesheet1 = 'providers/edit.css'
    @provider = Provider.new
    @amenities = Amenity.find(:all, :order => 'name')
  end

  def create
    $custom_stylesheet1 = 'providers/edit.css'
    Provider.transaction do
      @provider = Provider.new(params[:provider])
      full_address = [@provider.address1,',',@provider.city,',',@provider.state,' ',@provider.zip].to_s
      location = SearchUtility.get_coordinates(full_address)
      @provider.latitude = location[0] rescue nil
      @provider.longitude = location[1] rescue nil
      if @provider.save
        unless (params[:provider_amenities].blank? || params[:provider_amenities][:amenity_ids].blank?)
          params[:provider_amenities][:amenity_ids].each do |amenity_id|
            provider_amenity = ProviderAmenity.new
            provider_amenity.provider_id = @provider.id
            provider_amenity.amenity_id = amenity_id
            @provider.provider_amenities << provider_amenity    
          end  
        end
        flash[:notice] = 'Provider was successfully created.'
        redirect_to :action => 'show', :id => @provider
      else
        @amenities = Amenity.find(:all, :order => 'name')
        render :action => 'new'
      end
    end
  end

  def edit
    $custom_stylesheet1 = 'providers/edit.css'
    @provider = Provider.find(params[:id])
    @amenities = Amenity.find(:all, :order => 'name')
  end

  def update
    $custom_stylesheet1 = 'providers/edit.css'
    Provider.transaction do
      @provider = Provider.find(params[:id])
      if @provider.update_attributes(params[:provider])
        full_address = [@provider.address1,',',@provider.city,',',@provider.state,' ',@provider.zip].to_s
        location = SearchUtility.get_coordinates(full_address)
        @provider.latitude = location[0].to_f rescue nil
        @provider.longitude = location[1].to_f rescue nil
        ProviderAmenity.delete_all(["provider_id = ?",@provider.id])
        unless params[:provider_amenities].blank? || params[:provider_amenities][:amenity_ids].blank?    
          params[:provider_amenities][:amenity_ids].each do |amenity_id|
            provider_amenity = ProviderAmenity.new
            provider_amenity.provider_id = @provider.id
            provider_amenity.amenity_id = amenity_id
            @provider.provider_amenities << provider_amenity    
          end  
        end
        flash[:notice] = 'Provider was successfully updated.'
        redirect_to :action => 'show', :id => @provider
      else
        @amenities = Amenity.find(:all, :order => 'name')
        render :action => 'edit'
      end
    end
  end

  def destroy
    Provider.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def psnew
    $custom_stylesheet1 = 'providers/edit.css'
    @provider = Provider.find(params[:id])
    @provider_service = ProviderService.new
    @provider_service.provider_id = @provider.id
    @services = Service.find(:all, 
                             :select => :services,
                             :include => :cpt_code,
                             :order => "cpt_codes.code, name",
                             :joins => ["left outer join provider_services ps on ps.service_id = services.id and ps.provider_id = ",@provider.id],
                             :conditions => "ps.service_id is null" )
  end
  
  def pscreate
    $custom_stylesheet1 = 'providers/edit.css'
    ProviderService.transaction do
      @provider_service = ProviderService.new(params[:provider_service])
      if @provider_service.save
        flash[:notice] = 'Provider Service was successfully created.'
        redirect_to :action => 'show', :id => @provider_service.provider_id
      else
        @provider = Provider.find(params[:provider_service][:provider_id])
        @services = Service.find(:all,
                                 :select => :services,
                                 :include => :cpt_code,
                                 :order => "cpt_codes.code, name",
                                 :joins => ["left outer join provider_services ps on ps.service_id = services.id and ps.provider_id = ",@provider.id],
                                 :conditions => "ps.service_id is null" )
        render :action => 'psnew'
      end
    end    
  end

  def psedit
    $custom_stylesheet1 = 'providers/edit.css'
    @provider_service = ProviderService.find(params[:id])    
    @provider = @provider_service.provider
    @services = Service.find(:all, 
                             :select => :services,
                             :include => :cpt_code,
                             :order => "cpt_codes.code, name",
                             :joins => ["left outer join provider_services ps on ps.service_id = services.id and ps.provider_id = ",@provider.id],
                             :conditions => ["(ps.service_id is null or ps.service_id = ?)",@provider_service.service_id] )
  end
  
  def pssave
    @provider_service = ProviderService.find(params[:id])
    if @provider_service.update_attributes(params[:provider_service])
      flash[:notice] = 'Provider service was successfully updated.'
      redirect_to :action => 'show', :id => @provider_service.provider_id
    else
      @provider = @provider_service.provider
      render :action => 'edit_price'
    end
  end
  
  def psdelete
    provider_service = ProviderService.find(params[:id])
    provider_id = provider_service.provider.id
    provider_service.destroy
    redirect_to :action => 'show', :id => provider_id
  end
  
end

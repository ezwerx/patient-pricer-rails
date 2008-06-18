class AmenitiesController < ApplicationController

  layout "main"

  def initialize
    $active_tab = 'amenities'
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
    @amenities = Amenity.find(:all, :order => "name", :page => {:size => 15, :current => params[:page], :first => 1})
  end

  def show
    @amenity = Amenity.find(params[:id])
  end

  def new
    $custom_stylesheet1 = 'amenities/edit.css'
    @amenity = Amenity.new
  end

  def create
    @amenity = Amenity.new(params[:amenity])
    if @amenity.save
      flash[:notice] = 'Amenity was successfully created.'
      redirect_to :action => 'list'
    else
      $custom_stylesheet1 = 'amenities/edit.css'
      render :action => 'new'
    end
  end

  def edit
    $custom_stylesheet1 = 'amenities/edit.css'
    @amenity = Amenity.find(params[:id])
  end

  def update
    @amenity = Amenity.find(params[:id])
    if @amenity.update_attributes(params[:amenity])
      flash[:notice] = 'Amenity was successfully updated.'
      redirect_to :action => 'show', :id => @amenity
    else
      $custom_stylesheet1 = 'amenities/edit.css'
      render :action => 'edit'
    end
  end

  def destroy
    Amenity.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

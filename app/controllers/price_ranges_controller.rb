class PriceRangesController < ApplicationController

  layout "main"

  def initialize
    $active_tab = 'price_ranges'
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
    @price_ranges = PriceRange.find(:all, :order => "position", :page => {:size => 15, :current => params[:page], :first => 1})
  end

  def show
    @price_range = PriceRange.find(params[:id])
  end

  def new
    $custom_stylesheet1 = 'amenities/edit.css'
    @price_range = PriceRange.new
  end

  def create
    @price_range = PriceRange.new(params[:price_range])
    if @price_range.save
      flash[:notice] = 'PriceRange was successfully created.'
      redirect_to :action => 'list'
    else
      $custom_stylesheet1 = 'amenities/edit.css'
      render :action => 'new'
    end
  end

  def edit
    $custom_stylesheet1 = 'amenities/edit.css'
    @price_range = PriceRange.find(params[:id])
  end

  def update
    @price_range = PriceRange.find(params[:id])
    if @price_range.update_attributes(params[:price_range])
      flash[:notice] = 'PriceRange was successfully updated.'
      redirect_to :action => 'list', :id => @price_range
    else
      $custom_stylesheet1 = 'amenities/edit.css'
      render :action => 'edit'
    end
  end
  
  def up
    PriceRange.find(params[:id]).move_higher
    redirect_to :action => 'list'
  end

  def down
    PriceRange.find(params[:id]).move_lower
    redirect_to :action => 'list'
  end

  def destroy
    PriceRange.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

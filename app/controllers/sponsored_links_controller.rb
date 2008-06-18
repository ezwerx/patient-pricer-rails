class SponsoredLinksController < ApplicationController

  layout "main"

  def initialize
    $active_tab = 'sponsored_links'
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
    @sponsored_links = SponsoredLink.find(:all, :page => {:size => 20, :current => params[:page], :first => 1})
  end

  def show
    @sponsored_link = SponsoredLink.find(params[:id])
  end

  def new
    @sponsored_link = SponsoredLink.new
  end

  def create
    @sponsored_link = SponsoredLink.new(params[:sponsored_link])
    if @sponsored_link.save
      flash[:notice] = 'SponsoredLink was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sponsored_link = SponsoredLink.find(params[:id])
  end

  def update
    @sponsored_link = SponsoredLink.find(params[:id])
    if @sponsored_link.update_attributes(params[:sponsored_link])
      flash[:notice] = 'SponsoredLink was successfully updated.'
      redirect_to :action => 'show', :id => @sponsored_link
    else
      render :action => 'edit'
    end
  end

  def destroy
    SponsoredLink.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

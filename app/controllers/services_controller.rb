class ServicesController < ApplicationController

  layout 'main'

  auto_complete_for :service, :name

  def initialize
    $active_tab = 'services'
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
    @services = Service.find(:all, :include => [:cpt_code], :order => "cpt_codes.code", :page => {:size => 20, :current => params[:page], :first => 1})
    
  end
  
  def search
    @q = 'xray'
    @services = Service.paginating_ferret_search({:q => @q, :page_size => 20, :current => params[:p], :first => 1})
    #render :action => 'list'
  end

  
  def show
    @service = Service.find(params[:id])
    @cpt_codes = CptCode.find(:all, :order => 'code')
  end

  def new
    @service = Service.new
    @cpt_codes = CptCode.find(:all, :order => 'code')
  end

  def create
    
    Service.transaction do
    
      @service = Service.new(params[:service])
      
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
      
    end
    
  end

  def edit
    @service = Service.find(params[:id])
    @cpt_codes = CptCode.find(:all, :order => 'code')
  end

  def update

    @service = Service.find(params[:id])
    
    if @service.update_attributes(params[:service])
      flash[:notice] = 'Service was successfully updated.'
      redirect_to :action => 'show', :id => @service
    else
      render :action => 'edit'
    end
  end

  def destroy
    Service.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

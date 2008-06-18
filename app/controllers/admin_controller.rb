class AdminController < ApplicationController

    layout "main"

    $active_tab = 'home'
    #$home_is_active = 'active'
    #$dictionary_is_active = ''
    #$services_is_active = ''
    #$providers_is_active = ''    

    def initialize
      $custom_stylesheet1 = ''
    end
    
  def index
    render :action => 'index'
  end

end

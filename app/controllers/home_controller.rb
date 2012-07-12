class HomeController < ApplicationController
  
  def index
    @page = 'home'
    render :layout => "marketing_new"
  end

  def product
    @page = 'product'
    render :layout => "marketing_new"
  end  

end

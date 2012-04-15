class HomeController < ApplicationController
  
  def index
    @page = 'home'
    render :layout => "marketing"
  end

  def product
    @page = 'product'
    render :layout => "marketing"
  end  
  
end

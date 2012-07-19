class HomeController < ApplicationController
  
  def index
    @page = 'home'
    render 'index', :layout => "marketing"
  end

  def product
    @page = 'product'
    render 'product', :layout => "marketing"
  end  
  
end

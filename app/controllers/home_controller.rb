class HomeController < ApplicationController

  def index
    @page = 'home'
    @current_user = current_user
    render 'index', :layout => "marketing"
  end

  def product
    @page = 'product'
    render 'product', :layout => "marketing"
  end  
  
end

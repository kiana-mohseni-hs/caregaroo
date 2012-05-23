class HomeController < ApplicationController
  
  def index
    @page = 'home'
    render :layout => "marketing"
  end
  
  def home_new
    @page = 'home'
    render 'index_new', :layout => "marketing_new"
  end

  def product
    @page = 'product'
    render :layout => "marketing"
  end  
  
end

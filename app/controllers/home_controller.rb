class HomeController < ApplicationController
  before_filter :prepare_for_mobile
  
  def index
    @page = 'home'
    render :layout => "marketing"
  end

  def product
    @page = 'product'
    render :layout => "marketing"
  end  
  
  def home_new
    @page = 'home'
    render 'index_new', :layout => "marketing_new"
  end
  
  def product_new
    @page = 'product'
    render 'product_new', :layout => "marketing_new"
  end
  
end

class HomeController < ApplicationController

  def index
    @page = 'home'
    render 'index_new', :layout => "marketing_new"
  end

  def product
    @page = 'product'
    render 'product_new', :layout => "marketing_new"
  end  
  
end

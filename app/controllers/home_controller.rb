class HomeController < ApplicationController
  before_filter :prepare_for_mobile

  def index
    @page = 'home'
<<<<<<< HEAD
    @session = Session.new if mobile_device?
    render :layout => "marketing"
=======
    render 'index_new', :layout => "marketing_new"
>>>>>>> master
  end

  def product
    @page = 'product'
    render 'product_new', :layout => "marketing_new"
  end  
  
end

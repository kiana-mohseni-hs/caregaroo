class DownloadController < ApplicationController
  
  def ebook
      send_file Rails.root.join('app','assets','download','HowToCareForYou-EBook-by-Caregaroo.pdf'), :type=>"application/pdf"      
  end
  
  def faq
      send_file Rails.root.join('app','assets','download','PilotProgramFAQ.pdf'), :type=>"application/pdf"      
  end

end
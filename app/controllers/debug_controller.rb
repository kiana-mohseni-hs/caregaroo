class DebugController < ApplicationController
  before_filter :only_development

  def become_this_guy
    cookies[:auth_token] = User.find(params[:id]).auth_token
    redirect_to posts_path
  end

  def only_development
    unless Rails.env.development?
      redirect_to "/"
      return false
    end
  end

end

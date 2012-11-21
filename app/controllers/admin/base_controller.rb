class Admin::BaseController < ApplicationController

	layout "admin_panel"
	
  before_filter :require_system_admin
  before_filter :set_columns, :only => :index

  protected

  # [dataTables]
  def conditions
    c = []
    a = {}

    @columns.each_with_index do |column, i|
      if params["bSearchable_#{i}"] && !params["sSearch_#{i}"].blank?

        dbname  = column[:db_name]
        dbname_ = dbname.gsub(/\W+/, '')
        search  = params["sSearch_#{i}"].strip

        case column[:type]        
        when "string"
          c << "#{dbname} LIKE :#{dbname_}"
          a[("#{dbname_}").to_sym] = "%#{search}%"        
        when "int"
          c << "#{dbname} = :#{dbname_}"
          a[("#{dbname_}").to_sym] = search        
        end

      end
    end

    [c.join(" AND "), a]
  end

  # [dataTables]
  def current_page
    params[:iDisplayStart].to_i / per_page + 1
  end

  # [dataTables]
  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  # [dataTables]
  def sort_column
    @columns[params[:iSortCol_0].to_i][:db_name]
  end

  # [dataTables]
  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  private
  def require_system_admin
    @current_user = current_user

    unless @current_user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end
    
    unless @current_user.is_system_admin?
      redirect_to root_path
      return false
    end
  end

  def set_columns
  end

end
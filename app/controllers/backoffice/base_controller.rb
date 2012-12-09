class Backoffice::BaseController < ApplicationController

	layout "backoffice"
	
  before_filter :require_system_admin
  before_filter :set_columns, :only => :index

  protected

  # [dataTables]
  #
  # Build basic conditions based on default column types (column[:type])
  # Can be overridden in the child controller if there's any 'special' column type
  def conditions
    # c = conditions; a = arguments
    c = []
    a = {}

    @columns.each_with_index do |column, i|
      if params["bSearchable_#{i}"] && !params["sSearch_#{i}"].blank?

        dbname  = column[:db_name]
        dbname_ = dbname.gsub(/\W+/, '')
        search  = params["sSearch_#{i}"].strip.downcase

        case column[:type]
        
        when "string"
          c << "LOWER(#{dbname}) LIKE :#{dbname_}"
          a[("#{dbname_}").to_sym] = "%#{search}%"
        
        when "int"
          c << "#{dbname} = :#{dbname_}"
          a[("#{dbname_}").to_sym] = search
        
        when "date_ranges"
          case search
          # when "all_time"
          when "yesterday"
            c << "#{dbname} BETWEEN :start AND :end"
            a[:start] = 1.day.ago.beginning_of_day
            a[:end]   = 1.day.ago.end_of_day
          when "last_week"
            c << "#{dbname} BETWEEN :start AND :end"
            a[:start] = 1.week.ago.beginning_of_week
            a[:end]   = 1.week.ago.end_of_week
          when "last_month"
            c << "#{dbname} BETWEEN :start AND :end"
            a[:start] = 1.month.ago.beginning_of_month
            a[:end]   = 1.month.ago.end_of_month
          end
        end

      end
    end

    [c.join(" AND "), a]
  end

  # [dataTables]
  # iDisplayStart contains the start point in the current data set.
  def current_page
    params[:iDisplayStart].to_i / per_page + 1
  end

  # [dataTables]
  # iDisplayLength contains the number of records that the table can display in the current draw. 
  #   It is expected that the number of records returned will be equal to this number, unless the 
  #   server has fewer records to return.
  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  # [dataTables]
  # iSortCol_0 contains the number of the column being sorted on
  def sort_column
    @columns[params[:iSortCol_0].to_i][:db_name]
  end

  # [dataTables]
  # sSortDir_0 contains the direction to be sorted
  def sort_direction
    params[:sSortDir_0]
  end

  private

  # [dataTables]
  #
  # Must be overridden in the child controller
  #
  # @columns = [
  #   {
  #     :db_name    => String 
  #     :human_name => String 
  #     :type       => String
  #       - Used to define which filter should be applied
  #       - Options: int | string | date_ranges | ""
  #       - Obs: Leave blank if none apply. Eg.: Networks > Email of Initiator
  #     :filter     => Boolean
  #     :sortable   => Boolean
  #     :invisible  => Boolean
  #   }
  # ]
  def set_columns
  end

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

end
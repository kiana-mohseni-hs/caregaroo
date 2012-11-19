class Admin::UsersController < Admin::BaseController

  def index
    @records = User.order("#{sort_column} #{sort_direction}")
                .includes(:networks)
                .paginate(:page => current_page, :per_page => per_page)

    # TODO: add filtering per column
    # http://www.datatables.net/examples/api/multi_filter.html
    if params[:sSearch].present?
      @records = @records.where("email like :search", search: "%#{params[:sSearch]}%")
    end

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        User.count,
          iTotalDisplayRecords: @records.total_entries,
          aaData:               format_data(@records)
        }
      }
    end
  end

  private
  def set_columns
    @columns = [
      {:db_name => "email",      :human_name => "Email"},
      {:db_name => "first_name", :human_name => "First Name"},
      {:db_name => "last_name",  :human_name => "Last Name"},
      {:db_name => "networks",   :human_name => "Networks", :sortable => false},
      {:db_name => "last_login", :human_name => "Last Login"}
    ]
  end

  def format_data(records)
    records.map do |r|

      networks = r.networks.map { |n| 
        %(<a href="#{url_for :controller => 'networks', :action => 'show', :id => n.id}">#{n.name}</a>)
      }.join(', ') unless r.networks.nil?

      [r.email, r.first_name, r.last_name, networks, ""]

    end
  end

end
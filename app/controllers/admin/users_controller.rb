class Admin::UsersController < Admin::BaseController

  def index
    @records = User.order("#{sort_column} #{sort_direction}")
                .includes(:networks)
                .paginate(:page => current_page, :per_page => per_page)

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

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
  # [dataTables]
  def set_columns
    @columns = [
      {:db_name => "email",         :human_name => "Email",      :type => "string", :filter => true},
      {:db_name => "first_name",    :human_name => "First Name", :type => "string", :filter => true},
      {:db_name => "last_name",     :human_name => "Last Name",  :type => "string", :filter => true},
      {:db_name => "networks.name", :human_name => "Networks",   :type => "string", :filter => true, :sortable => false}#,
      #{:db_name => "last_login",    :human_name => "Last Login", :type => "date",   :filter => false}
    ]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      networks = r.networks.map { |n| 
        %(<a href="#{url_for :controller => 'networks', :action => 'show', :id => n.id}">#{n.name}</a>)
      }.join(', ') unless r.networks.nil?

      [r.email, r.first_name, r.last_name, networks, ""]

    end
  end

end
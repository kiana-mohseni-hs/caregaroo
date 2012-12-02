class Backoffice::UsersController < Backoffice::BaseController

  def index
    # need to include networks because I'll use it to filter records
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
      {:db_name => "updated_at",    :human_name => "Last Seen",  :type => "date_interval", :filter => true},
      {:db_name => "networks.name", :human_name => "Networks",   :type => "string", :filter => true, :sortable => false}
    ]
  end

  def conditions
    c, a = super
    c = [c]

    @columns.each_with_index do |column, i|
      if params["bSearchable_#{i}"] && !params["sSearch_#{i}"].blank?

        dbname  = column[:db_name]
        dbname_ = dbname.gsub(/\W+/, '')
        search  = params["sSearch_#{i}"].strip.downcase

        case dbname

        when "updated_at"
          #require 'debugger'; debugger;
          # todo -> break, test both, query if makes sense
          #if( is_iso_date?(search) && true )
          logger.info("updated_at>> #{search} ?#{is_iso_date?(search)}")
        end

      end
    end

    c.reject!(&:empty?)

    [c.join(" AND "), a]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      networks = r.networks.map { |n| 
        %(<a href="#{url_for :controller => 'networks', :action => 'show', :id => n.id}">#{n.name}</a>)
      }.join(', ') unless r.networks.nil?

      [r.email, r.first_name, r.last_name, r.updated_at.strftime("%y-%m-%d"), networks]

    end
  end

end
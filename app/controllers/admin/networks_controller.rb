class Admin::NetworksController < Admin::BaseController

  def index
    # need to include affiliations > users because I'll use them to filter records
    @records = Network.includes(:affiliations => :user)
                .paginate(:page => current_page, :per_page => per_page)
                .order("#{sort_column} #{sort_direction}")

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        Network.count,
          iTotalDisplayRecords: @records.total_entries,
          aaData:               format_data(@records)
        }
      }
    end
  end

  protected
  # [dataTables]
  def conditions
    c, a = super

    c = [c]

    @columns.each_with_index do |column, i|
      if params["bSearchable_#{i}"] && !params["sSearch_#{i}"].blank?

        dbname  = column[:db_name]
        dbname_ = dbname.gsub(/\W+/, '')
        search  = params["sSearch_#{i}"].strip.downcase

        case dbname

        when "users.email"
        	c << "affiliations.role = :role AND LOWER(users.email) LIKE :initiator"
        	a[:role] = User::ROLES["initiator"]
        	a[:initiator] = "%#{search}%"

        when "networks.created_at"
          case search
          # when "all_time"
          when "yesterday"
            c << "networks.created_at BETWEEN :start AND :end"
            a[:start] = 1.day.ago.beginning_of_day
            a[:end]   = 1.day.ago.end_of_day
          when "last_week"
            c << "networks.created_at BETWEEN :start AND :end"
            a[:start] = 1.month.ago.beginning_of_week
            a[:end]   = 1.month.ago.end_of_week
          when "last_month"
            c << "networks.created_at BETWEEN :start AND :end"
            a[:start] = 1.month.ago.beginning_of_month
            a[:end]   = 1.month.ago.end_of_month
          end
        end

      end
    end

    c.reject!(&:empty?)

    [c.join(" AND "), a]
  end

  private
  # [dataTables]
  def set_columns
    @columns = [
      {:db_name => "name",                :human_name => "Name",               :type => "string", :filter => true},
      {:db_name => "network_for_who",     :human_name => "Network For",        :type => "string", :filter => false},
      {:db_name => "users.email",         :human_name => "Email of Initiator", :type => "",       :filter => true},
      {:db_name => "users_count",         :human_name => "# of Members",       :type => "int",    :filter => true},
      {:db_name => "posts_count",         :human_name => "# of News",          :type => "int",    :filter => true},
      {:db_name => "events_count",        :human_name => "# of Events",        :type => "int",    :filter => true},
      {:db_name => "networks.created_at", :human_name => "Created at",         :type => "select", :filter => true,
        :filter_name => "Date Range",
        :invisible   => true,
        :options     => [
          {:value => "all_time",   :name => "All Time"},
          {:value => "yesterday",  :name => "Yesterday"},
          {:value => "last_week",  :name => "Last Week"},
          {:value => "last_month", :name => "Last Month"}
        ]
      }
    ]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      initiator = r.affiliations.select { |u| u.role == User::ROLES["initiator"] }.first.user

      [r.name, r.network_for_who, initiator.email, r.users_count, r.posts_count, r.events_count, r.created_at]

    end
  end

end
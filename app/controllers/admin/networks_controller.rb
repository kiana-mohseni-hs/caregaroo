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
        search  = params["sSearch_#{i}"].strip

        case dbname
        when "users.email"
        	c << "affiliations.role = :role AND users.email LIKE :initiator"
        	a[:role] = User::ROLES["initiator"]
        	a[:initiator] = "%#{search}%"
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
      {:db_name => "name",         :human_name => "Name",               :type => "string", :filter => true},
      {:db_name => "for",          :human_name => "Network For",        :type => "string", :filter => false},
      {:db_name => "users.email",  :human_name => "Email of Initiator", :type => "",       :filter => true},
      {:db_name => "users_count",  :human_name => "# of Members",       :type => "int",    :filter => true},
      {:db_name => "posts_count",  :human_name => "# of News",          :type => "int",    :filter => true},
      {:db_name => "events_count", :human_name => "# of Events",        :type => "int",    :filter => true}
    ]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      initiator = r.affiliations.select { |u| u.role == User::ROLES["initiator"] }.first.user

      [r.name, r.network_for_who, initiator.email, r.users_count, r.posts_count, r.events_count]

    end
  end

end
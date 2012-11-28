class Admin::EventsController < Admin::BaseController

  def index
    # need to include user and network because I'll use them to filter records
    @records = Event.unscoped
                .includes(:creator, :updater, :event_type, :network)
                .paginate(:page => current_page, :per_page => per_page)
                .order("#{sort_column} #{sort_direction}")

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        Event.count,
          iTotalDisplayRecords: @records.total_entries,
          aaData:               format_data(@records)
        }
      }
    end
  end

  protected
  # [dataTables]
  def conditions
    # c = conditions; a = arguments
    c, a = super

    c = [c]

    @columns.each_with_index do |column, i|
      if params["bSearchable_#{i}"] && !params["sSearch_#{i}"].blank?

        dbname  = column[:db_name]
        dbname_ = dbname.gsub(/\W+/, '')
        search  = params["sSearch_#{i}"].strip.downcase

        case dbname
        when "creator_email"
          c << "users.id = events.created_by_id AND LOWER(users.email) LIKE :creator"
          a[:creator] = "%#{search}%"
        when "updater_email"
          c << "users.id = events.updated_by_id AND LOWER(users.email) LIKE :updater"
          a[:updater] = "%#{search}%"
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
      {:db_name => "events.name",       :human_name => "Event Title",   :type => "string",      :filter => true},
      {:db_name => "description",       :human_name => "Description",   :type => "string",      :filter => true},
      {:db_name => "creator_email",     :human_name => "Creator Email", :type => "",            :filter => true,  :sortable => false},
      {:db_name => "updater_email",     :human_name => "Updater Email", :type => "",            :filter => false, :sortable => false},
      {:db_name => "networks.name",     :human_name => "Network Name",  :type => "string",      :filter => true},
      {:db_name => "event_types.name",  :human_name => "Event Type",    :type => "string",      :filter => true},
      {:db_name => "events.created_at", :human_name => "Created date",  :type => "date_ranges", :filter => true},
      {:db_name => "events.updated_at", :human_name => "Updated date",  :type => "date",        :filter => false}
    ]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      network = %(<a href="#{url_for :controller => 'networks', :action => 'show', 
        :id => r.network_id}">#{r.network.name}</a>) unless r.network.nil?

      creator = %(<a href="#{url_for :controller => 'users', :action => 'show', 
        :id => r.created_by_id}">#{r.creator.email}</a>) unless r.creator.nil?

      updater = %(<a href="#{url_for :controller => 'users', :action => 'show', 
        :id => r.created_by_id}">#{r.updater.email}</a>) unless r.updater.nil?

      [r.name, r.description, creator, updater, network, r.event_type.name, 
        r.created_at.to_s(:long), r.updated_at.to_s(:long)]

    end
  end

end
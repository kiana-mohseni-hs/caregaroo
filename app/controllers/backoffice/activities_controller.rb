class Backoffice::ActivitiesController < Backoffice::BaseController

  def index
    where, arguments = conditions
    
    aaData = [User, Post, Event, Invitation].map do |m|
      m = m.where(where, arguments) unless where.blank?
      m.count
    end

    # need to add another value because I have 5 columns and 4 values here.
    # the 5th column is invisible, so the value can be empty.
    aaData << ""

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        1,
          iTotalDisplayRecords: 1,
          aaData:               [aaData]
        }
      }
    end
  end

  private
  # [dataTables]
  def set_columns
    @columns = [
      # Total number of logins
      {:db_name => "total_users",      :human_name => "# of New Registrations", :type => "string",      :filter => false, :sortable => false},
      {:db_name => "total_news",       :human_name => "# of News Updates",      :type => "string",      :filter => false, :sortable => false},
      {:db_name => "total_events",     :human_name => "# of Events",            :type => "string",      :filter => false, :sortable => false},
      {:db_name => "total_invitatios", :human_name => "# of Invitations",       :type => "string",      :filter => false, :sortable => false},
      {:db_name => "created_at",       :human_name => "Date range",             :type => "date_ranges", :filter => true,  :sortable => false, :invisible => true}
    ]
  end

end
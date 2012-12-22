class Backoffice::LandpageController < Backoffice::BaseController

  def index
    # need to include networks because I'll use it to filter records
    @records = LandpageData.order("#{sort_column} #{sort_direction}")
                .includes(:user)
                .paginate(:page => current_page, :per_page => per_page)

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        LandpageData.count,
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
      {:db_name => "landpage_data.email",      :human_name => "Email",            :type => "string",      :filter => true},
      {:db_name => "users.id",                 :human_name => "Registered User?", :type => "int",         :filter => false},
      {:db_name => "landpage_data.campaign",   :human_name => "Campaign",         :type => "string",      :filter => true},
      {:db_name => "landpage_data.created_at", :human_name => "Created date",     :type => "date_ranges", :filter => true}
    ]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      email = r.user.blank? ? r.email : %(<a href="#{url_for :controller => 'users', :action => 'show', 
        :id => r.user.id}">#{r.user.email}</a>)

      registered = r.user.blank? ? %(<span class="label label-important">No</span>) : 
        %(<span class="label label-info">Yes</span>)

      [email, registered, r.campaign, r.created_at.to_s(:long)]

    end
  end

end
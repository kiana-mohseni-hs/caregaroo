class Backoffice::InvitationsController < Backoffice::BaseController

  def index
    # need to include networks because I'll use it to filter records
    @records = Invitation.order("#{sort_column} #{sort_direction}")
                .includes(:sender, :network)
                .paginate(:page => current_page, :per_page => per_page)

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        Invitation.count,
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
      {:db_name => "users.email",            :human_name => "Email of sender",    :type => "string",      :filter => true},
      {:db_name => "invitations.email",      :human_name => "Email of recipient", :type => "string",      :filter => true},
      {:db_name => "networks.name",          :human_name => "Networks",           :type => "string",      :filter => true},
      {:db_name => "invitations.created_at", :human_name => "Created date",       :type => "date_ranges", :filter => true}
    ]

    # *Email of sender (filter)
    # *Email of recipient (filter)
    # *network name    
    # *Created date / Date range: (all time, yesterday, last week, last month) [rolling time window]
  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      sender = %(<a href="#{url_for :controller => 'users', :action => 'show', 
        :id => r.send_id}">#{r.sender.email}</a>) unless r.sender.nil?

      network = %(<a href="#{url_for :controller => 'networks', :action => 'show', 
        :id => r.network_id}">#{r.network.name}</a>) unless r.network.nil?

      [sender, r.email, network, r.created_at.to_s(:long)]

    end
  end

end
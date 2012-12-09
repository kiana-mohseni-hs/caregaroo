class Backoffice::NewsController < Backoffice::BaseController

  def index
    # need to include user and network because I'll use them to filter records
    @records = Post.unscoped
                .includes(:user, :network)
                .paginate(:page => current_page, :per_page => per_page)
                .order("#{sort_column} #{sort_direction}")

    # individual column filtering
    where, arguments = conditions
    @records = @records.where(where, arguments) unless where.blank?

    respond_to do |format|
      format.html
      format.json { render :json => {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        Post.count,
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
      {:db_name => "posts.name",       :human_name => "News Title",   :type => "string",      :filter => true},
      {:db_name => "content",          :human_name => "News Content", :type => "string",      :filter => true},
      {:db_name => "networks.name",    :human_name => "Network Name", :type => "string",      :filter => true},
      {:db_name => "users.email",      :human_name => "User Email",   :type => "string",      :filter => true},
      {:db_name => "posts.created_at", :human_name => "Created date", :type => "date_ranges", :filter => true},
      {:db_name => "posts.updated_at", :human_name => "Updated date", :type => "",            :filter => false}
    ]

  end

  # [dataTables]
  def format_data(records)
    records.map do |r|

      network = %(<a href="#{url_for :controller => 'networks', :action => 'show', 
        :id => r.network_id}">#{r.network.name}</a>) unless r.network.nil?

      user = %(<a href="#{url_for :controller => 'users', :action => 'show', 
        :id => r.user_id}">#{r.user.email}</a>) unless r.user.nil?

      [r.name, r.content, network, user, r.created_at.to_s(:long), r.updated_at.to_s(:long)]

    end
  end

end
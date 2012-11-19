class Admin::DashboardController < Admin::BaseController

  def index
  end

  private
  def set_columns
    @db_columns    = []
    @human_columns = []
  end

end

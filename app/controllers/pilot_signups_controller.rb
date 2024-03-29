class PilotSignupsController < ApplicationController
  respond_to :html, :js, :json
  before_filter :require_user_admin, :only => [:index, :destroy]
    
  def index
    @pilot_signups   = PilotSignup.all
    render :layout => "admin"
  end

  def destroy
    @pilot_signup = PilotSignup.find(params[:id])
    if !@pilot_signup.nil?
      @pilot_signup.destroy
    end
    respond_to do |format|
      format.html { redirect_to pilot_signups_url }
      format.json { head :ok }
    end
  end
   
=begin
# GET /pilot_signups/1
# GET /pilot_signups/1.json
def show
  @pilot_signup = PilotSignup.find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.json { render :json => @pilot_signup }
  end
end

  # GET /pilot_signups/new
  # GET /pilot_signups/new.json
  def new
    @pilot_signup = PilotSignup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @pilot_signup }
    end
  end

  # GET /pilot_signups/1/edit
  def edit
    @pilot_signup = PilotSignup.find(params[:id])
  end

  # POST /pilot_signups
  # POST /pilot_signups.json
  def create
    @pilot_signup = PilotSignup.new(params[:pilot_signup])
      
  #  flash[:notice] = "Comment successfully created" if @pilot_signup.save
  #  respond_with( @pilot_signup, :layout => request.xhr? )

    respond_to do |format|
      if @pilot_signup.save
        format.html { redirect_to @pilot_signup, :notice => 'Pilot signup was successfully created.' }
        format.js { render :js => @pilot_signup, :status => :created, :location => @pilot_signup }
      else
        format.html { render :action => "new" }
        format.js { render :js => @pilot_signup.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /pilot_signups/1
  # PUT /pilot_signups/1.json
  def update
    @pilot_signup = PilotSignup.find(params[:id])

    respond_to do |format|
      if @pilot_signup.update_attributes(params[:pilot_signup])
        format.html { redirect_to @pilot_signup, :notice => 'Pilot signup was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @pilot_signup.errors, :status => :unprocessable_entity }
      end
    end
  end

 
=end
end

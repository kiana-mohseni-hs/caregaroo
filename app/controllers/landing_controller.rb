class LandingController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def fb_tab
		render layout: 'facebook_tab'
	end

	# decide where to redirect our user from this point
	def fb_tab_post
		@email = params[:email].strip.downcase
		return redirect_to fb_tab_url if @email.blank? 

		user = User.find_by_email @email
		# do we have this guy as our user already?
		session[:landing_email] = @email
		if user
			redirect_to login_url
		else
			LandpageData.create!(email: @email, campaign: 'fb_tab') unless LandpageData.find_by_email @email
			redirect_to register_url
		end

	end

end

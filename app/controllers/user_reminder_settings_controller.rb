class UserReminderSettingsController < ApplicationController

	def destroy
		@user = User.find(params[:user_id])
		@user_reminder_setting = @user.user_reminder_settings.find(params[:id])
		@user_reminder_setting.destroy
		@number_of_reminders = @user.user_reminder_settings.size

		respond_to :js
	end

	def create
		@user = User.find(params[:user_id])
		@user_reminder_setting = UserReminderSetting.create(params[:user_reminder_setting])
		@user.user_reminder_settings << @user_reminder_setting
		@number_of_reminders = @user.user_reminder_settings.size

		respond_to :js
	end

end
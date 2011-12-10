ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => "587",
  :domain               => "caregaroo.com",
  :user_name            => "app@caregaroo.com",
  :password             => "4MdRA+3[",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
# port 465, 587
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

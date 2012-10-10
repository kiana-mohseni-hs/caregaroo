source 'http://rubygems.org'

gem 'rails', "~> 3.2.8"
gem 'bcrypt-ruby'

group :development do
  gem 'sqlite3'
end

gem 'pg'
gem 'thin'
gem "fog", "~> 1.3.1"

group :assets do
  #gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git", :branch => "static"
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'compass_twitter_bootstrap'
  gem 'fancy-buttons'
  gem 'jquery-ui-rails'

  # jsvascript compressor
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
# gem 'jquery_datepicker'
gem 'jquery-timepicker-rails'
gem 'event-calendar', :require => 'event_calendar'
gem 'fancybox-rails'

# background jobs and queues
gem 'resque', :require => "resque/server"
gem 'resque-scheduler', :require => 'resque_scheduler'
# image cropper
gem 'carrierwave'
gem 'rmagick'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem 'backbone-on-rails'
gem 'jbuilder'
gem 'validates_timeliness', '~> 3.0'

# speed up asset precompile
gem 'turbo-sprockets-rails3'
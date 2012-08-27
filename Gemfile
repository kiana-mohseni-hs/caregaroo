source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'bcrypt-ruby'

group :development do
  gem 'sqlite3'
end

group :test, :production do
  gem 'mysql2'
end

group :heroku do
  gem 'pg'
  gem 'thin'
  gem "fog", "~> 1.3.1"
end


group :assets do
  #gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git", :branch => "static"
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'compass_twitter_bootstrap'
  gem 'fancy-buttons'

  # jsvascript compressor
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'event-calendar', :require => 'event_calendar'

# background jobs and queues
gem 'resque', :require => "resque/server"
# image cropper
gem 'carrierwave'
gem 'rmagick'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem 'backbone-on-rails'
gem 'jbuilder'

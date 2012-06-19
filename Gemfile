source 'http://rubygems.org'

gem 'thin'
gem 'rails', '3.2.2'
gem 'bcrypt-ruby'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3'
end

group :test, :production do
  gem 'pg'
end

group :assets do
  #gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git", :branch => "static"
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'compass_twitter_bootstrap'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

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

# gem "mail", "2.1.3"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

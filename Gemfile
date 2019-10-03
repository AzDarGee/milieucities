source 'https://rubygems.org'

gem 'rails', '5.2.3'

# rails core gems
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'rack-cors'
gem 'httparty'
gem 'figaro'
# gem "webpacker"

# background services gems
gem 'whenever'
gem 'resque', require: 'resque/server'
gem 'mandrill-api'

# model gems
gem 'carrierwave'
gem 'rolify'
gem 'friendly_id'
gem 'cancancan'
gem 'geokit-rails'
gem 'bcrypt'
gem 'fog'
gem 'rmagick'
gem 'simple_command'
gem 'jwt'
gem 'closure_tree'
gem 'textacular'

# view gems
gem 'font-awesome-rails'
gem 'momentjs-rails'
gem 'rabl'
gem 'cocoon'

# database gems
gem 'pg'
gem 'redis'

# omniauth gems
gem 'therubyracer'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-npm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-resque', require: false
  gem 'pry-rails'
  gem 'spring'
  gem 'letter_opener'
  gem 'dotenv-rails'
  gem 'puma'
  gem 'better_errors'
  gem 'foreman'
  gem 'rubocop', require: false
end

group :test do
  gem 'dotenv-rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'minitest-reporters'
  gem 'mini_backtrace'
end

group :production, :staging do
  gem 'unicorn'
  gem 'puma'
  gem 'rails_12factor'
end

ruby '2.6.0'

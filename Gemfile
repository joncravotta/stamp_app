source 'https://rubygems.org'

ruby "2.3.0"
# AWS web server
#gem 'puma', '~> 3.4'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Bourbon because it's awesome (scss helpers)
gem 'bourbon', '~> 4.2', '>= 4.2.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# React rails gem
gem 'react-rails', '~> 1.6', '>= 1.6.2'
#responing to post request
gem 'responders', '~> 2.2'
# Getting images size
gem 'fastimage', '~> 1.8'
# Auth
gem 'devise', '~> 4.2'
# Payments
gem 'stripe'
# Carrier wave
gem 'carrierwave', github:'carrierwaveuploader/carrierwave'
gem 'mini_magick'
gem 'fog', '~> 1.38'
# cdn for images
gem 'cloudinary', '~> 1.2', '>= 1.2.2'

gem 'rails_real_favicon'

# devise add on for inviting users to app
gem 'devise_invitable', '~> 1.7.0'

gem 'font-awesome-sass', '~> 4.7.0'



# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'dotenv-rails'
  gem "minitest-rails", "~> 2.0"
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

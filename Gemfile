source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'devise'
gem 'omniauth-google-oauth2'

gem 'haml-rails'
gem 'redcarpet'

# System
gem 'pg'
gem 'carrierwave'
gem 'fog'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'rspec-rails'
  gem 'spork-rails'
  gem 'thin'
  gem 'faker'
  gem 'timecop'
end

group :production do
  gem 'thin'
  gem 'rails_12factor'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem "codeclimate-test-reporter", require: nil
  # Code analysis tools
  gem 'rubocop'
  gem 'rails_best_practices'
  gem 'reek'
  gem 'jslint_on_rails'
end

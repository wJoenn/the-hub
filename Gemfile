source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.17.0", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# [https://github.com/jnunemaker/httparty]
gem "httparty"

# Github rest api fetcher [https://github.com/octokit/octokit.rb]
gem "octokit", "~> 8.0.0"

# A multithreaded, Postgres-based, ActiveJob backend [https://github.com/bensheldon/good_job#set-up]
gem "good_job", "~> 3.22.0"

gem "sentry-ruby", "~> 5.15.0"

gem "sentry-rails", "~> 5.15.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'

  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "simplecov"

  gem "rubocop", "~> 1.59.0", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", "~> 2.23.1", require: false
  gem "rubocop-rspec", require: false

  gem 'fasterer', '~> 0.11.0'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # [https://github.com/fly-apps/dockerfile-rails]
  gem "dockerfile-rails", "~> 1.5.12"
end

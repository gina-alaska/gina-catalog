source 'https://rubygems.org'

gem 'dotenv-rails', require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'rb-readline'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rdiscount'
gem 'haml'
gem 'omniauth'
#gem 'omniauth-github'
#gem 'omniauth-google-oauth2'
gem 'omniauth-openid'
gem 'google-api-client'
gem 'bootstrap_form', '~> 2.3.0' #git: 'https://github.com/bootstrap-ruby/rails-bootstrap-forms.git'
gem 'awesome_nested_set'
gem 'rgeo'
gem 'rgeo-activerecord'
gem 'activerecord-postgis-adapter', '3.0.0'
gem 'rgeo-geojson'
gem 'cancancan', '~> 1.9'
gem 'nested_form'
gem 'dragonfly', '~> 1.0.1'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'uuidtools'
gem 'searchkick'
gem 'ransack'
gem 'quiet_assets', group: [:development, :test]
gem 'georuby'
gem 'kaminari'
gem 'stamp'
gem 'public_activity'
gem 'active_link_to'
gem 'simple_form'
gem 'friendly_id'
gem 'html-pipeline'
# gem 'mustache'
# gem 'flavour_saver'
gem 'handlebars'
gem 'github-markdown'
gem 'closure_tree'
gem 'acts_as_list'
gem "refile", '~> 0.6.1', require: ["refile/rails", "refile/simple_form"]
gem "refile-mini_magick"
gem 'rack-cors', require: 'rack/cors'
gem 'hightop'
gem 'version'
gem 'request_store'

group :development, :production do
  gem 'rails_12factor'
  gem 'rack-cache'
  gem 'dalli'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # gem 'better_errors'
  # gem 'binding_of_caller'
  # gem 'rails-erd'
  gem 'guard'
  gem 'guard-minitest'
  gem 'mocha', require: false
  gem 'shoulda', require: false
  gem 'shoulda-matchers', require: false
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'minitest-rails-capybara'
  gem 'guard-rubocop'
  gem 'pry-rails'
end

gem 'bundler', '>= 1.8.4'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  # gem 'rails-assets-font-awesome'
  gem 'rails-assets-jasny-bootstrap'
  gem 'rails-assets-handlebars'
  gem 'rails-assets-mapbox.js', '~> 2.1.5'
  gem 'rails-assets-typeahead.js', '~> 0.10.5'
  gem 'rails-assets-selectize', '~> 0.11.2'
  gem 'rails-assets-holderjs', '~> 2.4.0'
  gem 'rails-assets-moment'
  gem 'rails-assets-leaflet.markercluster', '0.4.0.hotfix.1'
  # gem 'rails-assets-wicket'
  gem 'rails-assets-uri.js'
  gem 'rails-assets-ace-builds'
  gem 'rails-assets-bootstrap-submenu'
end
gem "font-awesome-rails"

group :development do
  gem "capistrano", "~> 3.4"
  gem 'capistrano-rails', '~> 1.1'
end

require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/connection_adapters/postgis_adapter/railtie'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env) if defined?(Bundler)

if defined?(Bundler)
  #If you precompile assets before deploying to production, use this line
  #Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in produciton, use this line
  Bundler.require(:default, :assets, Rails.env)
end


module NSCatalog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.paths << "#{Rails.root}/vendor/assets/jquery"
    config.assets.paths << "#{Rails.root}/vendor/assets/javascripts"

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/extras)
    config.eager_load_paths += [ "#{Rails.root}/app/workers"]
    
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Alaska'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    require 'pdfkit'
    config.middleware.use PDFKit::Middleware
    
    # config.middleware.insert 0, 'Rack::Cache', {
    #   :verbose     => true,
    #   :metastore   => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"),
    #   :entitystore => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
    # } # unless Rails.env.production?  ## uncomment this 'unless' in Rails 3.1,
    #                               ## because it already inserts Rack::Cache in production

    # config.middleware.insert_after 'Rack::Cache', 'Dragonfly::Middleware', :media
  end
end

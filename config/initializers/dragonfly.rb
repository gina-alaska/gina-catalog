require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "0459566660f764cff9928b6b1384b9db8dfc2652058d5b4f291af43f9615403c"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/cms'),
    server_root: Rails.root.join('public')
    
  processor :page do |content, *args|
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end

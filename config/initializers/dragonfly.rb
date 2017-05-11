require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret 'e539164fa4aae51623983ebe65b4e243c82af5ddddbccdb92377e78b233549ff'

  url_format '/media/:job/:name'

  datastore :file,
            root_path: ::File.join(Rails.application.secrets.glynx_storage_path, 'dragonfly'),
            server_root: Rails.root.join('public')
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

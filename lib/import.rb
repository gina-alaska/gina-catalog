require 'import/client'
require 'import/base'
require 'import/entry'
require 'import/contact'
require 'import/organization'
require 'import/collection'

module Import
  API_URL = Rails.application.secrets.glynx2_api || 'http://glynx2-api.127.0.0.1.xip.io'
end

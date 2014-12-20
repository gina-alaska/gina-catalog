require 'test_helper'

class SocialNetworkTest < ActiveSupport::TestCase
  should belong_to(:portal)
  should belong_to(:social_network_config)

  should delegate_method(:name).to(:social_network_config)
  should delegate_method(:icon).to(:social_network_config)
  
  should validate_uniqueness_of(:social_network_config_id).scoped_to(:portal_id)
end

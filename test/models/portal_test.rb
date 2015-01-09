require 'test_helper'

class PortalTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:acronym)
  
  should have_many(:urls)
  should have_many(:activity_logs)
  should have_many(:social_networks)

  should accept_nested_attributes_for(:urls).allow_destroy(true)
  should accept_nested_attributes_for(:social_networks).allow_destroy(true)
  should accept_nested_attributes_for(:favicon).allow_destroy(true)

  should have_one(:favicon)
  
  def setup
    @portal = portals(:one)
  end
  
  test "default_url should return the default url" do
    assert_equal @portal.default_url.url, 'catalog.192.168.222.225.xip.io'
  end

  test "build_social_networks should initialize available networks" do
    @portal.social_networks.destroy_all
    assert_difference("@portal.social_networks.size", SocialNetworkConfig.count) do
      @portal.build_social_networks
    end
  end

  test "build_social_networks should only initialize missing networks" do
    assert_difference("@portal.social_networks.size", SocialNetworkConfig.count - @portal.social_networks.size) do
      @portal.build_social_networks
    end
  end
end

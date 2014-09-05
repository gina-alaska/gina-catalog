require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@site = sites(:one)
  end


  test "sites should have urls" do
  	assert !@site.urls.empty?
	end

	test "sites should have only one default url" do
		@site.urls.create(url: 'test.com', default: true)
		assert !@site.valid?, "Site came back as valid when it should be invalid"
	end
end

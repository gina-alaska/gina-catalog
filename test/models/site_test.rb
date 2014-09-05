require 'test_helper'

class SiteTest < ActiveSupport::TestCase
<<<<<<< HEAD
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
=======
  should validate_presence_of(:title)
  should validate_presence_of(:acronym)
  
  should have_many(:urls)
  
  should accept_nested_attributes_for(:urls).allow_destroy(true)
>>>>>>> 2dfccd1101e1c9cd3b6cb386e0fd36b7efae84a5
end

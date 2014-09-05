require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:acronym)
  
  should have_many(:urls)
  
  should accept_nested_attributes_for(:urls).allow_destroy(true)
end

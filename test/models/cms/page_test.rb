require 'test_helper'

class Cms::PageTest < ActiveSupport::TestCase
  should validate_presence_of(:title)  
end

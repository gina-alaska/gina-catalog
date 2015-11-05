require 'test_helper'

class Cms::LayoutTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
end

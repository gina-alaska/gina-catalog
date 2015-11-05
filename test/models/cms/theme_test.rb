require 'test_helper'

class Cms::ThemeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
end

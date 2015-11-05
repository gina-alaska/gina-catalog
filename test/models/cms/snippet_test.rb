require 'test_helper'

class Cms::SnippetTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
end

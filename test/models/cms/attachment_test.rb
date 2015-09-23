require "test_helper"

class Cms::AttachmentTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
end

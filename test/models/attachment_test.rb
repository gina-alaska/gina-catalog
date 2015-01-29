require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  should ensure_length_of(:description).is_at_most(255)

  should belong_to(:entry)

  should validate_presence_of :file_uid
  should validate_presence_of :uuid
end

require "test_helper"

class DownloadTest < ActiveSupport::TestCase
  should belong_to(:attachment)
  should belong_to(:entry)
  should ensure_length_of(:type).is_at_most(255)

end

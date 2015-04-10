require "test_helper"

class DownloadTest < ActiveSupport::TestCase
  should belong_to(:attachment)
  should have_one(:entry).through(:attachment)
end

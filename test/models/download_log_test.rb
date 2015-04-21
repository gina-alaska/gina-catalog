require "test_helper"

class DownloadLogTest < ActiveSupport::TestCase

  should belong_to(:user)
  should belong_to(:entry)
  should belong_to(:portal)

  should validate_length_of(:file_name).is_at_most(255)

  def download_log
    @download_log ||= DownloadLog.new
  end

  def test_valid
    assert download_log.valid?
  end

end

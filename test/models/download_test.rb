require "test_helper"

class DownloadTest < ActiveSupport::TestCase

  def download
    @download ||= Download.new
  end

  def test_valid
    assert download.valid?
  end

end

require 'test_helper'

class DownloadTest < ActiveSupport::TestCase
  should ensure_length_of(:name).is_at_most(255)
  should ensure_length_of(:file_type).is_at_most(255)
  should ensure_length_of(:url).is_at_most(255)
  should ensure_length_of(:uuid).is_at_most(255)
  
  should belong_to(:entry)
end

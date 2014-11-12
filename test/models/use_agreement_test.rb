require 'test_helper'

class UseAgreementTest < ActiveSupport::TestCase
  should ensure_length_of(:title).is_at_most(255)

  should validate_presence_of(:title)
  should validate_presence_of(:body)

  should belong_to(:portal)
  should have_many(:entries)
end

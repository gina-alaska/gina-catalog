require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase

  should have_many(:entries)

  should validate_presence_of(:name)
  should validate_presence_of(:color)  
  
  should ensure_length_of(:name).is_at_most(255)
  should ensure_length_of(:description).is_at_most(255)
  should ensure_length_of(:color).is_at_most(255)

end

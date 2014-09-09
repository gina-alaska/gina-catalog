require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  should belong_to(:site)
  should belong_to(:owner_site)
  should have_many(:entry_contacts)
  should have_many(:contacts).through(:entry_contacts)

  should ensure_length_of(:title).is_at_most(255)
  should ensure_length_of(:slug).is_at_most(255)
  should ensure_length_of(:uuid).is_at_most(255)
end

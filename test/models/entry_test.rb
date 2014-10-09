require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  should have_many(:entry_contacts)
  should have_many(:contacts).through(:entry_contacts)
  should have_many(:entry_aliases)
  should have_many(:entry_agencies)
  should have_many(:agencies).through(:entry_agencies)

  should ensure_length_of(:title).is_at_most(255)
  should validate_presence_of(:title)
  should ensure_length_of(:slug).is_at_most(255)
  should ensure_length_of(:sites).is_at_least(1)
  
  test "should have all relationships tested" do
    flunk("Need to add site and owner site relationship tests")
  end
  
  test "shouldn't allow more than one owner site" do
    flunk "Not implemented"
  end
  
  test "on create the first site should become the owner site" do
    @entry = Entry.create(title: 'Testing', sites: [sites(:one)])

    assert @entry.valid?, "Entry was not valid: #{@entry.errors.full_messages.join(', ')}"
    assert @entry.owner_site.present?, "Owner site was empty"
  end
  
  test "owner_site_count should return the correct counts" do
    flunk "not implemented"
  end
end

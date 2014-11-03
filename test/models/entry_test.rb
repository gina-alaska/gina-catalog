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
  #should ensure_length_of(:sites).is_at_least(1)
  
  test "should have all relationships tested" do
    belong_to(:site)
    belong_to(:owner_site)
    belong_to(:entry_type)
    have_many(:entry_sites)
    have_many(:sites).through(:entry_sites)
    have_one(:owner_entry_site)
    have_one(:owner_site)
  end
  
  test "ensure length of sites is at least 1" do
    @entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", sites: [sites(:one)])

    assert @entry.sites.count == 1, "sites are not 1"
  end

  test "shouldn't allow more than one owner site" do
    @entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", sites: [sites(:one)])
    @entry.set_owner_site
    @entry.sites << sites(:two)
    @entry.entry_sites.last.update_attribute(:owner, true)

    assert @entry.check_for_single_ownership, "There is only one owner site"
  end
  
  test "on create the first site should become the owner site" do
    @entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", sites: [sites(:one)])

    assert @entry.valid?, "Entry was not valid: #{@entry.errors.full_messages.join(', ')}"
    assert @entry.owner_site.present?, "Owner site was empty"
  end
  
  test "owner_site_count should return the correct counts" do
    @entry = Entry.create(title: 'Testing', sites: [sites(:one)])
    @entry.set_owner_site

    assert @entry.owner_site_count == 1, "Owner site count is not 1"
  end
end

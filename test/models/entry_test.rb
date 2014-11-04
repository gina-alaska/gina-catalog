require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def setup
    @entry = entries(:one)
    @multiowners = entries(:multi_owner)
  end
  
  should have_many(:entry_contacts)
  should have_many(:contacts).through(:entry_contacts)
  should have_many(:entry_aliases)
  should have_many(:entry_agencies)
  should have_many(:agencies).through(:entry_agencies)

  should ensure_length_of(:title).is_at_most(255)
  should validate_presence_of(:title)
  should validate_presence_of(:status)  
  should validate_presence_of(:entry_type_id)    
  should ensure_length_of(:slug).is_at_most(255)
  #should ensure_length_of(:sites).is_at_least(1)
  
  should belong_to(:entry_type)
  should have_many(:entry_sites)
  should have_many(:sites).through(:entry_sites)
  should have_one(:owner_entry_site)
  should have_one(:owner_site).through(:owner_entry_site)
  
  test "ensure length of sites is at least 1" do
    entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", entry_type: entry_types(:one), sites: [sites(:one), sites(:two)])

    assert entry.sites.count >= 1, "sites are not 1"
  end

  test "shouldn't allow more than one owner site" do
    @entry.entry_sites.each { |es| es.update_attribute(:owner, true) }
    assert !@entry.valid?    
    assert_equal ['cannot specify more than one owner'], @entry.errors['sites']
  end
  
  test "on create the first site should become the owner site" do
    entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", entry_type: entry_types(:one), sites: [sites(:one), sites(:two)])

    assert entry.valid?, "Entry was not valid: #{@entry.errors.full_messages.join(', ')}"
    assert entry.owner_site.present?, "Owner site was empty"
  end
  
  test "owner_site_count should return the correct counts" do
    assert_equal 1, @entry.owner_site_count
    assert_equal 2, @multiowners.owner_site_count
  end
end

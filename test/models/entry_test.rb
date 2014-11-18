require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def setup
    @entry = entries(:one)
    @multiowners = entries(:multi_owner)
  end
  
  should have_many(:attachments)
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
  #should ensure_length_of(:portals).is_at_least(1)
  
  should belong_to(:entry_type)
  should have_many(:entry_portals)
  should have_many(:portals).through(:entry_portals)
  should have_one(:owner_entry_portal)
  should have_one(:owner_portal).through(:owner_entry_portal)
  
  test "ensure length of portals is at least 1" do
    entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", entry_type: entry_types(:one), portals: [portals(:one), portals(:two)])

    assert entry.portals.count >= 1, "portals are not 1"
  end

  test "shouldn't allow more than one owner portal" do
    @entry.entry_portals.each { |es| es.update_attribute(:owner, true) }
    assert !@entry.valid?    
    assert_equal ['cannot specify more than one owner'], @entry.errors['portals']
  end
  
  test "on create the first portal should become the owner portal" do
    entry = Entry.create(title: 'Testing', description: "test", status: "Unknown", entry_type: entry_types(:one), portals: [portals(:one), portals(:two)])

    assert entry.valid?, "Entry was not valid: #{@entry.errors.full_messages.join(', ')}"
    assert entry.owner_portal.present?, "Owner portal was empty"
  end
  
  test "owner_portal_count should return the correct counts" do
    assert_equal 1, @entry.owner_portal_count
    assert_equal 2, @multiowners.owner_portal_count
  end
end

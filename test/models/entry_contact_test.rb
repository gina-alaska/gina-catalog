require 'test_helper'

class EntryContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not allow duplicate contacts on the same entry' do
    entry = entries(:one)
    contact = contacts(:one)

    ec = entry.entry_contacts.create(contact: contact)
    assert_not ec.valid?, 'Second entry contact was valid'
  end

  test 'should allow duplicate contacts on the same entry if one is primary' do
    entry = entries(:one)
    contact = contacts(:one)

    ec = entry.entry_contacts.create(contact: contact, primary: true)
    assert ec.valid?
  end
end

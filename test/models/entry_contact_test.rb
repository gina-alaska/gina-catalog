require 'test_helper'

class EntryContactTest < ActiveSupport::TestCase
  should belong_to(:entry)
  should belong_to(:contact)

  test 'should allow contact if email is blank' do
    entry = entries(:one)
    contact = contacts(:no_email)

    assert entry.entry_contacts.create(contact: contact)
  end

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

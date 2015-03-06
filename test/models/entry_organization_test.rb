require 'test_helper'

class EntryOrganizationTest < ActiveSupport::TestCase
  should belong_to(:entry)
  should belong_to(:organization)

  test 'should not allow duplicate organizations on the same entry' do
    entry = entries(:one)
    organization = organizations(:one)

    eo = entry.entry_organizations.create(organization: organization)
    assert_not eo.valid?, 'Second entry organization was valid'
  end

  test 'should allow duplicate organizations on the same entry if one is primary or funding' do
    entry = entries(:one)
    organization = organizations(:one)

    eo = entry.entry_organizations.create(organization: organization, primary: true)
    assert eo.valid?, 'Second entry organization was valid'

    eof = entry.entry_organizations.create(organization: organization, funding: true)
    assert eof.valid?, 'Third entry organization was valid'
  end
end

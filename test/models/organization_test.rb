require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  should validate_length_of(:name).is_at_most(255)
  should validate_uniqueness_of(:name)
  should validate_length_of(:category).is_at_most(255)
  should validate_length_of(:description).is_at_most(255)
  should validate_length_of(:acronym).is_at_most(15)
  should validate_uniqueness_of(:acronym)
  should validate_length_of(:adiwg_code).is_at_most(255)
  should validate_length_of(:adiwg_path).is_at_most(255)
  should validate_length_of(:logo_uid).is_at_most(255)
  should validate_length_of(:logo_name).is_at_most(255)
  should validate_length_of(:url).is_at_most(255)

  should have_many(:entry_organizations)
  should have_many(:entries).through(:entry_organizations)

  test 'organization should not be deletable if assigned' do
    organization = organizations(:one)

    assert !organization.deletable?, 'organization is deletable but should not be'
  end

  test 'used_by_portal should include recent org' do
    recent = organizations(:recent)
    portal = portals(:one)

    assert Organization.used_by_portal(portal).include?(recent), 'Did not find recent organization'
  end

  test 'used_by_portal should not include old org' do
    old = organizations(:old)
    portal = portals(:one)

    assert !Organization.used_by_portal(portal).include?(old), 'Found old organization'
  end
end

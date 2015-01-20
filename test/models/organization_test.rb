require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  should ensure_length_of(:name).is_at_most(255)
  should ensure_length_of(:category).is_at_most(255)
  should ensure_length_of(:description).is_at_most(255)
  should ensure_length_of(:acronym).is_at_most(15)
  should ensure_length_of(:adiwg_code).is_at_most(255)
  should ensure_length_of(:adiwg_path).is_at_most(255)
  should ensure_length_of(:logo_uid).is_at_most(255)
  should ensure_length_of(:logo_name).is_at_most(255)
  should ensure_length_of(:url).is_at_most(255)

  should have_many(:entry_organizations)
  should have_many(:entries).through(:entry_organizations)
  
  test "organization should not be deletable if assigned" do
    organization = organizations(:one)

    assert !organization.deletable?, "organization is deletable but should not be"
  end

end

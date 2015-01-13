require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def setup
		@blank_contact = contacts(:blank)
	end

  should ensure_length_of(:phone_number).is_at_most(255)
  should ensure_length_of(:job_title).is_at_most(255)
  should ensure_length_of(:email).is_at_most(255)
  should ensure_length_of(:name).is_at_most(255)
  should have_many(:agency_contacts)
  should have_many(:agencies).through(:agency_contacts)
  should have_many(:entries).through(:entry_contacts)

  test "blank contacts are invalid" do
  	assert !@blank_contact.valid?, "Contact was valid when shouldn't be."
  end

  test "contact should not be deletable if assigned" do
    contact = contacts(:one)

    assert !contact.deletable?, "contact is deletable but should not be"
  end
  
end

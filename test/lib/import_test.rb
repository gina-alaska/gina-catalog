require 'test_helper'
require 'import'

class ImportTest < ActiveSupport::TestCase
  def setup
    icontact = import_items(:two)
    icontact.importable = contacts(:one)
    icontact.save
  end

  test 'should return a string' do
    assert Import::API_URL.length > 0
  end

  test 'should return a contact model' do
    assert_kind_of Contact, Import::Helpers.find_contact('id' => 2)
  end

  test 'should return an organization model' do
    assert_kind_of Organization, Import::Helpers.find_org('name' => 'Geographic Information Network of Alaska')
  end
end

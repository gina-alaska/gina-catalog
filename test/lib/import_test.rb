require 'test_helper'
require 'import'

class ImportTest < ActiveSupport::TestCase
  def setup
    icontact = import_items(:two)
    icontact.importable = contacts(:one)
    icontact.save
  end

  test 'should return a string' do
    assert !Import::API_URL.empty?
  end

  test 'should return a contact model' do
    assert_kind_of Contact, Import::Base.new.find_contact('id' => 2)
  end

  test 'should return an organization model' do
    assert_kind_of Organization, Import::Base.new.find_org('name' => 'Geographic Information Network of Alaska')
  end
end

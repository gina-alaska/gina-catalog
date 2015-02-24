require 'test_helper'
require 'import'

class Import::ContactTest < ActiveSupport::TestCase
  test 'should create valid contact' do
    contact_import = Import::Contact.new
    import = contact_import.create(
      'id' => 2,
      'name' => 'John Smith',
      'email' => 'foo@foo.com',
      'job_title' => 'Boss'
    )
    assert import.importable.valid?, import.importable.errors.full_messages
  end
end

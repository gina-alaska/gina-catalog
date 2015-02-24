require 'test_helper'
require 'import'

class Import::ClientTest < ActiveSupport::TestCase
  test 'should return API_URL with path' do
    assert_equal File.join(Import::API_URL, '1234'), Import::Client.api_url('1234')
  end

  test 'should return catalog api url' do
    assert_equal File.join(Import::API_URL, '/setups/123/catalogs.json'), Import::Client.catalog_records_url('123')
  end

  test 'should return agency api url' do
    assert_equal File.join(Import::API_URL, '/agencies.json'), Import::Client.agencies_url
  end

  test 'should return contact api url' do
    assert_equal File.join(Import::API_URL, '/contacts.json'), Import::Client.contacts_url
  end

  test 'should return a collection items' do
    assert Import::Client.fetch(Import::Client.agencies_url).count > 0, 'Did not find any items'
  end
end

require 'test_helper'
require 'import'

class Import::RegionTest < ActiveSupport::TestCase
  test 'should create valid region' do
    region_import = Import::Region.new
    import = region_import.create(
      'id' => 1,
      'name' => 'Alaska',
      'geom' => 'MULTIPOLYGON (((-168.24901 53.051919, -168.237302 52.950548)))'
    )
    assert import.importable.valid?, import.importable.errors.full_messages
  end
end

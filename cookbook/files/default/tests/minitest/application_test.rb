require File.expand_path('../support/helpers', __FILE__)

describe 'glynx::default' do
  include Helpers::Gina_catalog

  # Example spec tests can be found at http://git.io/Fahwsw
  describe 'application' do
    it 'should create the application directory' do
      directory(node['glynx']['paths']['application']).must_exist.with(:owner, node['glynx']['account'])
      directory(node['glynx']['paths']['shared']).must_exist.with(:owner, node['glynx']['account'])
    end

    it 'should create the sunspot config' do
      file(sunspot_config_file).must_exist.with(:owner, node['glynx']['account'])
    end

    it 'should create the rails database config' do
      file(rails_dbconfig_file).must_exist.with(:owner, node['glynx']['account'])
    end

    it 'should create the catalog initializer file' do
      file(catalog_initializer_file).must_exist.with(:owner, node['glynx']['account'])
    end

    it 'should create the .bundle/config file' do
      file(bundle_config_file).must_exist.with(:owner, node['glynx']['account'])
    end

    it 'should mount the catalog silo shared filesys' do
      directory(node['glynx']['mounts']['catalog_silo']['mount_point']).must_exist
    end
  end
end

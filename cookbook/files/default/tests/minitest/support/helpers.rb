module Helpers
  module Gina_catalog
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
    
    def sunspot_config_file
      File.join(node['glynx']['paths']['shared'], 'config/sunspot.yml')
    end
    
    def rails_dbconfig_file
      File.join(node['glynx']['paths']['shared'], 'config/database.yml')
    end
    
    def git_hooks_env_file
      File.join(node['glynx']['paths']['shared'], 'config/git_hooks_env')
    end
    
    def catalog_initializer_file
      File.join(node['glynx']['paths']['shared'], 'config/initializers/catalog.rb')
    end
    
    def dragonfly_initializer_file
      File.join(node['glynx']['paths']['shared'], 'config/initializers/dragonfly.rb')
    end

    def bundle_config_file
      "/home/#{node['glynx']['account']}/.bundle/config"
    end
    
    def unicorn_config
      File.join(node['glynx']['paths']['shared'], 'unicorn.rb')
    end
  end
end
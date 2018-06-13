default['glynx']['user'] = 'webdev'
default['glynx']['group'] = 'webdev'

default['glynx']['deploy_method'] = 'local'

default['glynx']['env'] = {
  RAILS_ENV: 'development',
  SECRET_KEY_BASE: ''
}

# Local install related configs
default['glynx']['install_path'] = '/var/www/glynx'
default['glynx']['release_path'] = '/var/www/glynx/current'
default['glynx']['dot_env_path'] = '/var/www/glynx/shared/.env'
default['glynx']['ruby_version'] = '2.3.1'
default['glynx']['storage_mount'] = '/mnt/glynx_storage'
# Habitat install related configs

#default['glynx']['package'] = 'HAB PACKAGE NAME'
#default['glynx']['package_checksum']

default['glynx']['user'] = 'webdev'
default['glynx']['group'] = 'webdev'

default['glynx']['install_path'] = '/var/www/glynx'
default['glynx']['release_path'] = '/var/www/glynx/current'
default['glynx']['dot_env_path'] = '/var/www/glynx/shared/.env'
default['glynx']['ruby_version'] = '2.1.0'

default['glynx']['env'] = {
  RAILS_ENV: 'development',
  SECRET_KEY_BASE: ''
}

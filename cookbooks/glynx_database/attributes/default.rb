default['postgresql']['enable_pgdg_yum'] = true
default['postgresql']['version'] = "9.4"
default['postgresql']['dir'] = "/var/lib/pgsql/9.4/data"
default['postgresql']['config']['data_directory'] = node['postgresql']['dir']
default['postgresql']['client']['packages'] = ["postgresql94", "postgresql94-devel"]
default['postgresql']['server']['packages'] = ["postgresql94-server"]
default['postgresql']['server']['service_name'] = "postgresql-9.4"
default['postgresql']['contrib']['packages'] = ['postgresql94-contrib', 'postgis2_94']
default['postgresql']['contrib']['extensions'] = ['hstore', 'postgis', 'postgis_topology']
default['postgresql']['setup_script'] = "postgresql94-setup"

default['postgresql']['config_pgtune']['db_type'] = 'web'
default['postgresql']['config']['listen_addresses'] = '0.0.0.0'

# override['postgresql']['config']['log_timezone'] = 'UTC'
# override['postgresql']['config']['timezone'] = 'UTC'

default['deploy']['environment'] = 'development'
override['deploy']['action'] = 'nothing'
override['deploy']['deploy_key'] = ''
default['deploy']['precompile_assets'] = false
default['deploy']['service_static_assets'] = false

override['app']['user'] = 'vagrant'
override['app']['group'] = 'vagrant'

default['glynx']['environment_aware'] = false

default['postgresql']['password']['postgres'] = "wombats"

default['postgresql']['pg_hba'] << {
  type: 'host',
  db: 'all',
  user: 'all',
  addr: 'all',
  method: 'md5'
}

default['iptables']['allow_from']['postgresql']['192.168.222.0/24'] = true
default['iptables']['allow_from']['postgresql']['10.0.2.0/24'] = true

default['glynx']['environment'] = 'production'

default['glynx']['paths'] = {
  application:        '/www/glynx',
  deploy:             '/www/glynx/current',
  shared:             '/www/glynx/shared',
  config:             '/www/glynx/shared/config',
  initializers:       '/www/glynx/shared/config/initializers',
  public:             '/www/glynx/shared/public'
}

default['glynx']['mounts'] = {
  catalog_silo: {
    device: 'pod.gina.alaska.edu:/pod/nssi_silo',
    fstype: 'nfs',
    options: 'rw',
    action: [:mount, :enable],
    mount_point: '/san/pod/catalog_silo'
  }
}

default['glynx']['links'] = {
  archive: { name: '/www/glynx/shared/archive',    to: '/san/pod/catalog_silo/archives', action: :create },
  repos:   { name: '/www/glynx/shared/repos',      to: '/san/pod/catalog_silo/git',      action: :create },
  uploads: { name: '/www/glynx/shared/uploads',    to: '/san/pod/catalog_silo/uploads',  action: :create },
  cms:     { name: '/www/glynx/shared/public/cms', to: '/san/pod/catalog_silo/cms',      action: :create }
}

default['glynx']['account'] = 'webdev'

default['glynx']['rails']['secrets'] = {
  development: {
    secret_key_base: '208dcab87ee1339b7c7e5ee9dd70f3a6a77814f3e203f959f2207b07a870a9960f095a5c24d2f29d3829c5099e512f1a91adc1d453a5675988694493e533e7b7'
  },
  test: {
    secret_key_base: 'eca191458f7576c2b76a81dca3f81c0436a557f07d322130a4fa9020cd89b1961f851392440942f04721f2dd1499a81c8ab466489c06ab25de446e9e7dd3617f'
  },
  production: {
    secret_key_base: '<%= ENV["SECRET_KEY_BASE"] %>'
  }
}

default['glynx']['database'] = {
  setup: false,
  environments: [:development, :test],
  development: {
    adapter: 'postgis',
    hostname: '192.168.222.225',
    database: 'glynx_development',
    username: 'glynx',
    password: 'fj329rghDDw02jf',
    search_path: 'public'
  },
  test: {
    adapter: 'postgis',
    hostname: '192.168.222.225',
    database: 'glynx_test',
    username: 'glynx',
    password: 'fj329rghDDw02jf',
    search_path: 'public'
  },
  production: {
    adapter: 'postgis',
    hostname: '192.168.222.225',
    database: 'glynx_production',
    username: 'glynx',
    password: '',
    search_path: 'public'
  }
}

# default['glynx']['database']['adapter']  = "postgis"
# default['glynx']['database']['hostname'] = "localhost"
# default['glynx']['database']['database'] = "nssi_prod"
# default['glynx']['database']['username'] = "nssi_prod"
# default['glynx']['database']['password'] = ""
# default['glynx']['database']['search_path'] = "nssi_prod,public"
# default['glynx']['database_setup'] = false

default['glynx']['sunspot']['solr']['hostname'] = '192.168.222.225'
default['glynx']['sunspot']['solr']['port'] = '8982'
default['glynx']['sunspot']['solr']['path'] = '/solr/default'
default['glynx']['sunspot']['hostname'] = '192.168.222.225'

default['glynx']['redis']['hostname'] = '192.168.222.225'

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'

default['elasticsearch']['cluster']['name'] = 'elasticsearch_glynx'

default['glynx']['package_deps'] = %w(
  patch
  libicu-devel
  curl-devel
  libxml2-devel
  libxslt-devel
  nfs-utils
  geos-devel
  proj-devel
  ImageMagick-devel
)

override['chruby']['version'] = '0.3.8'
override['chruby']['rubies'] = {
  '1.9.3-p392' => false,
  '1.9.3-p448' => false,
  '2.1.1' => true,
  '2.1.2' => true
}
# override['chruby']['default'] = '2.1.1'
default['glynx']['ruby_version'] = '2.1'

default['unicorn']['preload_app'] = true
default['unicorn']['config_path'] = '/etc/unicorn/glynx.rb'
default['unicorn']['listen'] = '/www/glynx/shared/tmp/sockets'
default['unicorn']['pid'] = '/www/glynx/shared/tmp/pids/unicorn.pid'
default['unicorn']['stderr_path'] = '/www/glynx/shared/log/unicorn.stderr.log'
default['unicorn']['stdout_path'] = '/www/glynx/shared/log/unicorn.stdout.log'
default['unicorn']['working_directory'] = '/www/glynx/current'
default['unicorn']['worker_timeout'] = 60
default['unicorn']['before_fork'] = '
defined?(ActiveRecord::Base) and
   ActiveRecord::Base.connection.disconnect!

 old_pid = "#{server.config[:pid]}.oldbin"
 if old_pid != server.pid
   begin
     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
     Process.kill(sig, File.read(old_pid).to_i)
   rescue Errno::ENOENT, Errno::ESRCH
   end
 end

sleep 1
'

default['unicorn']['after_fork'] = "
defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection

# If you are using Redis but not Resque, change this
# if defined?(Resque)
#   Resque.redis.client.reconnect
# end
"

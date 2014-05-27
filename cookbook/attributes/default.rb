default['glynx']['environment'] = 'production'

default['glynx']['application_path'] = "/www/glynx"
default['glynx']['shared_path'] = "#{default['glynx']['application_path']}/shared"
default['glynx']['config_path'] = "#{default['glynx']['shared_path']}/config"
default['glynx']['initializers_path'] = "#{default['glynx']['config_path']}/initializers"
default['glynx']['deploy_path'] = "#{default['glynx']['application_path']}/current"
default['glynx']['catalog_silo_path'] = "/san/pod/catalog_silo"
default['glynx']['dragonfly_uploads_path'] = "#{default['glynx']['shared_path']}/uploads"

default['glynx']['account'] = "webdev"

default['glynx']['database']['adapter']  = "postgis"
default['glynx']['database']['hostname'] = "localhost"
default['glynx']['database']['database'] = "nssi_prod"
default['glynx']['database']['username'] = "nssi_prod"
default['glynx']['database']['password'] = ""
default['glynx']['database']['search_path'] = "nssi_prod,public"
default['glynx']['database_setup'] = false

default['glynx']['sunspot']['solr']['hostname'] = 'localhost'
default['glynx']['sunspot']['solr']['port'] = '8982'
default['glynx']['sunspot']['solr']['path'] = '/solr/default'
default['glynx']['sunspot']['hostname'] = "localhost"

default['glynx']['redis']['hostname'] = 'localhost'

default['glynx']['package_deps'] = %w{
  java-1.7.0-openjdk 
  libicu-devel 
  curl-devel 
  libxml2-devel 
  libxslt-devel 
  nfs-utils 
  geos-devel 
  proj-devel
  ImageMagick-devel
}

override['chruby']['version'] = '0.3.8'
override['chruby']['rubies'] = {
  '1.9.3-p392' => false,
  '1.9.3-p448' => true
}
default['chruby']['default'] = '1.9.3-p448'

default['unicorn']['preload_app'] = true
default['unicorn']['config_path'] = '/etc/unicorn/glynx.rb'
default['unicorn']['listen'] = "#{default['glynx']['shared_path']}/tmp/sockets"
default['unicorn']['pid'] = "#{default['glynx']['shared_path']}/tmp/pids/unicorn.pid"
default['unicorn']['stderr_path'] = "#{default['glynx']['shared_path']}/log/unicorn.stderr.log"
default['unicorn']['stdout_path'] = "#{default['glynx']['shared_path']}/log/unicorn.stdout.log"
default['unicorn']['working_directory'] = "#{default['glynx']['deploy_path']}"
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
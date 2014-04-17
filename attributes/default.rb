#  Assuming webapp might use this variable at some point.
default['unicorn_config_path'] = '/etc/unicorn'

default['glynx']['application_path'] = "/www/glynx"
default['glynx']['shared_path'] = "#{default['glynx']['application_path']}/shared"
default['glynx']['config_path'] = "#{default['glynx']['shared_path']}/config"
default['glynx']['initializers_path'] = "#{default['glynx']['config_path']}/initializers"
default['glynx']['deploy_path'] = "#{default['glynx']['application_path']}/current"
default['glynx']['catalog_silo_path'] = "/san/pod/catalog_silo"
default['glynx']['dragonfly_uploads_path'] = "#{default['glynx']['shared_path']}/uploads"

default['glynx']['account'] = "webdev"

default['glynx']['database']['adapter']  = "postgis"
default['glynx']['database']['hostname'] = "yin.gina.alaska.edu"
default['glynx']['database']['database'] = "nssi_prod"
default['glynx']['database']['username'] = "nssi_prod"
default['glynx']['database']['password'] = "g0d0fn551"
default['glynx']['database']['search_path'] = "nssi_prod,public"

default['glynx']['sunspot']['hostname'] = "catalog-web1.x.gina.alaska.edu"
default['glynx']['sunspot']['port'] = "8983"

default['glynx']['redis']['hostname'] = "peanut.x.gina.alaska.edu"

default['glynx']['before_fork'] = '
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

default['glynx']['after_fork'] = "
defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection

# If you are using Redis but not Resque, change this
if defined?(Resque)
  Resque.redis.client.reconnect
end
"

default['glynx']['package_deps'] = %w{java-1.7.0-openjdk libicu-devel curl-devel libxml2-devel libxslt-devel nfs-utils geos-devel ImageMagick-devel}

default['users'] ||= []
%w{ webdev }.each do |user|
  default['users'] << user unless default['users'].include?(user)
end

PIDFILE=./tmp/pids/resque.pid \
BACKGROUND=yes \
QUEUE=imports_ng \
RAILS_ENV=production \
rake environment resque:work
PIDFILE=./tmp/pids/resque.pid \
BACKGROUND=yes \
QUEUE=* \
RAILS_ENV=production \
rake environment resque:work
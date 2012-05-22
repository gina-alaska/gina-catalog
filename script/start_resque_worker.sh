PIDFILE=./tmp/pids/resque.pid \
BACKGROUND=yes \
QUEUE=file_serve \
RAILS_ENV=production \
rake environment resque:work
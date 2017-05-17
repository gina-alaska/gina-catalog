workers Integer({{ cfg.web_concurrency }} || 1)
threads_count = Integer({{ cfg.max_threads }} || 5)
threads 1, threads_count

prune_bundler

rackup      DefaultRackup
port        "{{ cfg.rails_port }}"     || 9292
environment "{{ cfg.rails_env }}"      || 'development'
pidfile     "{{ cfg.rails_pidfile }}"  || './tmp/pids/puma.pid'
worker_timeout 240

app_path '/www/glynx/current'
chruby.environment 2.1
startup ['bundle install', 'service unicorn start', 'service solr_glynx start']

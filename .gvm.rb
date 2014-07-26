app_path '/www/glynx/current'
chruby.environment 1.9
startup ['bundle install', 'service unicorn_glynx start', 'service solr_glynx start']

app_path '/www/glynx/current'
chruby.environment 2.1
startup [
  'bundle',
  'run "rake db:migrate db:seed searchkick:reindex:all"',
  'run "rake db:migrate db:fixtures:load searchkick:reindex:all RAILS_ENV=test"',
  'service unicorn start'
]

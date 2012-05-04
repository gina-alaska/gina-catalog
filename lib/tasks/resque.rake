require 'resque/tasks'

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  
  Grit::Git.git_timeout = 10.minutes
  Grit::Git.git_max_size = 100.megabytes  
end

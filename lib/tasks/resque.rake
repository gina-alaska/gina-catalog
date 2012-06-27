require 'resque/tasks'

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  
  Grit::Git.git_timeout = 30.minutes
  Grit::Git.git_max_size = 400.megabytes  
end

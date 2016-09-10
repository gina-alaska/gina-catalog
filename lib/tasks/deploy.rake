require 'version'

namespace :deploy do
  desc "Deploy current version with capistrano"
  task :staging => :not_dirty do
    sh "cap staging deploy"
  end

  task :production => [:not_dirty] do
    sh "cap production deploy"
  end

  task :push_and_deploy => [:not_dirty] do
    puts "Pushing new version tag to git"
    sh "git push && git push --tags"

    puts "Pushing changes to staging"
    Rake::Task["deploy:staging"].invoke
    puts "Push complete please check staging and run `rake deploy:production` if accepted"
  end

  desc "Bump version to #{Version.current.bump!} and deploy"
  task :patch => [:not_dirty] do
    Rake::Task["version:bump"].invoke
    Rake::Task["deploy:push_and_deploy"].invoke
  end

  %w(minor major).each do |item|
    desc "Bump version to #{Version.current.bump!(item.to_sym)} and deploy"
    task item.to_sym => [:not_dirty] do
      Rake::Task["version:bump:#{item}"].invoke
      Rake::Task["deploy:push_and_deploy"].invoke
    end
  end

  task :not_dirty do
    abort "Aborting deploy, the current git repo is dirty! Please make sure there are no uncommited changes" unless `git status -suno`.chomp.empty?
  end
end

require 'version'

namespace :deploy do
  desc "Deploy current version with capistrano"
  task :cap => [:not_dirty] do
    sh "cap production deploy"
  end

  desc "Bump version to #{Version.current.bump!} and deploy"
  task :patch => [:not_dirty] do
    Rake::Task["version:bump"].invoke
    puts "Pushing new version tag to git"
    sh "git push && git push --tags"
    Rake::Task["deploy:cap"].invoke
  end

  %w(minor major).each do |item|
    desc "Bump version to #{Version.current.bump!(item.to_sym)} and deploy"
    task item.to_sym => [:not_dirty] do
      Rake::Task["version:bump:#{item}"].invoke
      puts "Pushing new version tag to git"
      sh "git push && git push --tags"
      Rake::Task["deploy:cap"].invoke
    end
  end

  task :not_dirty do
    abort "Aborting deploy, the current git repo is dirty! Please make sure there are no uncommited changes" unless `git status -suno`.chomp.empty?
  end
end

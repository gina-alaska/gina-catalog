namespace :dev do
  desc 'Rebuild development vm'
  task :rebuild do
    cd 'cookbook' do
      Bundler.with_clean_env do
        sh 'chef exec kitchen destroy; chef exec kitchen converge'
      end
    end
    sh 'rake dev:firstboot'
  end

  desc 'Run first boot tasks'
  task :firstboot do
    %w[development test].each do |env|
      sh "rake db:setup db:seed RAILS_ENV=#{env}"
      sh "rake searchkick:reindex:all RAILS_ENV=#{env}"
    end
  end
end

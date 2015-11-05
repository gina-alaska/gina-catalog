namespace :dev do
  desc 'Start the development vm'
  task :startvm do
    Bundler.with_clean_env do
      cd 'cookbook/.kitchen/kitchen-vagrant/kitchen-cookbook-default-bento-centos-67/' do
        sh 'vagrant up'
      end
    end
  end

  desc 'Bundle all the things'
  task :bundle do
    puts 'Bundling the local env'
    sh 'bundle'
    puts 'Bundling the development vm'
    Bundler.with_clean_env do
      cd 'cookbook' do
        sh 'kitchen converge'
      end
    end
  end
end

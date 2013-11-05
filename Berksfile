site :opscode
group :integration do
  cookbook 'minitest-handler'
end

cookbook "gina", "~> 0.3.6", chef_api: :config
cookbook "postgresql", chef_api: :config
cookbook "gina-postgresql", "~> 0.3.2", chef_api: :config

# cookbook "gina-webapp", path: "/Users/scott/workspace/cookbooks/gina-webapp" #chef_api: :config

cookbook "chruby"
cookbook "runit"
cookbook "application"
cookbook "application_ruby"
cookbook "application_nginx"
cookbook "user", git: 'http://github.com/fnichol/chef-user'

metadata

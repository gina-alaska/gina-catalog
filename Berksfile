site :opscode
group :integration do
  cookbook 'minitest-handler'
end

cookbook "nginx", '~> 2.2.0'
cookbook "yum", '~> 3.0'
cookbook "yum-epel"
cookbook "gina", '~> 0.5.5', chef_api: :config
cookbook "gina-postgresql", chef_api: :config
cookbook "sudo", '~> 2.5.2'

cookbook 'unicorn', '~> 1.0.0'
cookbook "chruby"
cookbook "user", git: 'http://github.com/fnichol/chef-user'

metadata

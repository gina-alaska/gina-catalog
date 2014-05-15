source 'https://api.berkshelf.com'
group :integration do
  cookbook 'minitest-handler'
end

cookbook "chruby"
#
# cookbook 'yum'
# cookbook 'yum-epel'
cookbook 'yum-gina', git: "git@github.com:gina-alaska/yum-gina-cookbook"
cookbook 'unicorn', '~> 1.3.0'
cookbook "nginx", '~> 2.6.0'
cookbook "gina-postgresql", '~> 0.4.0', git: "git@github.com:gina-alaska/gina-postgresql-cookbook"
# cookbook "sudo", '~> 2.5.2'
#
# cookbook "user", github: 'fnichol/chef-user'

metadata

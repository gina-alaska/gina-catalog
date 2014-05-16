name             'glynx'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures glynx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.0'

supports "centos", ">= 6.0"

depends "chruby"

# depends "user"
# depends "yum", '~> 3.0'
depends 'yum-gina'
depends 'yum-epel'
depends 'unicorn'
depends 'nginx'
depends 'redisio'
depends 'postgresql'
# depends "gina-postgresql", '~> 0.4.0'
# depends "sudo", '~> 2.5.2'

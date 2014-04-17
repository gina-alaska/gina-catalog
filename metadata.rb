name             'glynx'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures glynx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'

supports "centos", ">= 6.0"

depends "chruby"

depends "user"
depends "yum", '~> 3.0'
depends "yum-epel"
depends 'unicorn', '~> 1.0.0'
depends "gina", '~> 0.5.5'
depends "gina-postgresql"
depends "nginx"
depends "sudo", '~> 2.5.2'

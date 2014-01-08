name             'glynx'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures glynx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.13'

supports "centos", ">= 6.0"

depends "chruby"

depends "user"
depends "application_ruby"
depends "yum", "~> 2.4.4"
depends "gina", "= 0.4.6"
depends "postgresql"
depends "gina-postgresql"
depends "nginx"
# depends "gina-webapp"
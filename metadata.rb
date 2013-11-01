name             'glynx'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures glynx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "centos", ">= 6.0"

depends "application"
depends "application_ruby"
depends "application_nginx"
depends "chruby"
depends "runit"

depends "gina"
depends "gina-postgresql"
depends "gina-webapp"
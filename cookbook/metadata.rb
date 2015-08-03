name 'glynx'
maintainer 'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license 'All rights reserved'
description 'Installs/Configures glynx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.4'

supports 'centos', '>= 6.0'

depends 'chruby'
depends 'yum-gina'
depends 'yum-epel'
depends 'unicorn'
depends 'nginx'
depends 'redisio'
depends 'postgresql', '~> 3.4.20'
depends 'database', '~> 4.0.6'
depends 'runit'
depends 'java'
depends 'memcached'
depends 'now'
depends 'magic_shell'
depends 'elasticsearch', '~> 1.0.0'

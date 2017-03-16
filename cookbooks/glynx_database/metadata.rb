name 'glynx_database'
maintainer 'UAF GINA'
maintainer_email 'support+chef@gina.alaska.edu'
license 'mit'
description 'Installs/Configures glynx_database'
long_description 'Installs/Configures glynx_database'
version '0.1.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/glynx_database/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/glynx_database' if respond_to?(:source_url)

depends 'postgresql', '>= 6.1.1'
depends 'database'
depends 'chef-vault'
depends 'yum-epel'

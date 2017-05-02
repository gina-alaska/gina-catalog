name 'glynx_elasticsearch'
maintainer 'UAF GINA'
maintainer_email 'support+chef@gina.alaska.edu'
license 'mit'
description 'Installs/Configures glynx_elasticsearch'
long_description 'Installs/Configures glynx_elasticsearch'
version '0.2.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/glynx_elasticsearch/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/glynx_elasticsearch' if respond_to?(:source_url)

depends 'java'
depends 'elasticsearch'
depends 'gina_firewall'
depends 'limits'

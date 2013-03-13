class AddInitialPermissions < ActiveRecord::Migration
  PERMS = [{
    name: 'manage_cms', group: 'cms', description: 'User can create/edit cms content'
  },{
    name: 'manage_catalog', group: 'catalog', description: 'User can manage catalog content'
  },{
    name: 'manage_site', group: 'site_admin', description: 'User can site settings'
  },{
    name: 'manage_members', group: 'site_admin', description: 'User can invite/edit members'
  },{
    name: 'publish_catalog', group: 'catalog', description: 'User can publish catalog records'
  }]
  
  def up
    PERMS.each { |p| Permission.create(p) }
  end

  def down
    Permission.destroy_all
  end
end

class AddInitialPermissions < ActiveRecord::Migration
  PERMS = [{
    name: 'manage_cms', group: 'cms', description: 'Create/Edit CMS content'
  },{
    name: 'manage_catalog', group: 'catalog', description: 'Create/Edit catalog records'
  },{
    name: 'publish_catalog', group: 'catalog', description: 'Publish catalog records'
  },{
    name: 'manage_members', group: 'permissions', description: 'Invite members and assign roles'
  }]
  
  def up
    PERMS.each { |p| Permission.create(p) }
  end

  def down
    Permission.destroy_all
  end
end

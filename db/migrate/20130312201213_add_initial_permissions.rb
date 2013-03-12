class AddInitialPermissions < ActiveRecord::Migration
  PERMS = [{
    name: 'edit_cms_pages', group: 'cms', description: 'User can create/edit cms content'
  },{
    name: 'edit_feedback', group: 'cms', description: 'User can manage user feedback'
  },{
    name: 'edit_agencies', group: 'catalog', description: 'User can create/edit agencies'
  },{
    name: 'toggle_agencies', group: 'catalog', description: 'User can toggle visibility of agencies'
  },{
    name: 'edit_contacts', group: 'catalog', description: 'User can create/edit contacts'
  },{
    name: 'toggle_contacts', group: 'catalog', description: 'User can  toggle visibility of contacts'
  },{
    name: 'edit_catalog_records', group: 'catalog', description: 'User can create/edit catalog records'
  },{
    name: 'publish_catalog_records', group: 'catalog', description: 'User can publish catalog records'
  },{
    name: 'upload_catalog_data', group: 'catalog', description: 'User can upload data to catalog records'
  },{
    name: 'edit_collections', group: 'catalog', description: 'User can create/edit catalog collections'
  },{
    name: 'edit_site_settings', group: 'site_admin', description: 'User can edit site settings'
  },{
    name: 'edit_site_memberships', group: 'site_admin', description: 'User can edit site memberships'
  },{
    name: 'edit_site_roles', group: 'site_admin', description: 'User can edit site roles'
  },{
    name: 'edit_sites', group: 'uber_admin', description: 'User can create/edit sub-catalogs'
  }]
  
  def up
    PERMS.each { |p| Permission.create(p) }
  end

  def down
    PERMS.each { |p| Permission.where(p.slice(:name, :group)).first.try(:destroy) }
  end
end

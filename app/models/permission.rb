class Permission < ActiveRecord::Base
  AVAILABLE_ROLES = {
    cms_manager: 'User can edit CMS content',
    data_entry: 'User can create, edit, and archive catalog records',
    data_manager: 'User can create, edit, archive and publish catalog records',
    portal_manager: 'User can update settings and invite users'
  }.freeze

  belongs_to :user
  belongs_to :portal

  store_accessor :roles, *AVAILABLE_ROLES.keys
end

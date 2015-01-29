class Permission < ActiveRecord::Base
  AVAILABLE_ROLES = {
    cms_manager: 'User can edit CMS content',
    data_manager: 'User can edit catalog records',
    portal_manager: 'User can update settings and invite users'
  }

  belongs_to :user
  belongs_to :portal

  store_accessor :roles, *AVAILABLE_ROLES.keys
end

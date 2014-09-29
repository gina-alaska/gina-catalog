class Permission < ActiveRecord::Base
  AVAILABLE_ROLES = { cms_manager: 'User can edit CMS content', data_manager: 'User can edit catalog records', site_manager: 'User can update settings and invite users'}

  belongs_to :user
  belongs_to :site

  store_accessor :roles, *AVAILABLE_ROLES.keys
end

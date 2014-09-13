module PermissionConcerns
  extend ActiveSupport::Concern
  
  included do
  end
  
  def roles(site)
    self.site_users.for(site).try(:roles)
  end
  
  def set_roles(site, roles)
    site_user = self.site_users.where(site: site).first_or_initialize
    site_user.update_attribute(:roles, roles)
  end
  
  def has_role?(role, site)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean roles(site).try(:[], role.to_s)
  end
  
  module ClassMethods
    def available_roles
      %w{ cms_manager data_manager site_manager }
    end
  end
end
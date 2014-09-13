module PermissionConcerns
  extend ActiveSupport::Concern
  
  included do
    has_many :permissions do 
      def for(site)
        where(site_id: site).first
      end
    end
    has_many :sites, through: :permissions
  end
  
  def roles(site)
    self.permissions.for(site).try(:roles)
  end
  
  def set_roles(site, roles)
    permission = self.permissions.where(site_id: site).first_or_initialize
    permission.update_attribute(:roles, roles)
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
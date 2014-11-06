module PermissionConcerns
  extend ActiveSupport::Concern

  included do
    has_many :permissions do
      def for(portal)
        where(portal_id: portal).first
      end
    end
    has_many :portals, through: :permissions
  end

  def roles(portal)
    self.permissions.for(portal).try(:roles)
  end

  def set_roles(portal, roles)
    permission = self.permissions.where(portal_id: portal).first_or_initialize
    permission.update_attribute(:roles, roles)
  end

  def has_role?(role, portal)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean roles(portal).try(:[], role.to_s)
  end
end

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
    permissions.for(portal).try(:roles)
  end

  def set_roles(portal, roles)
    permission = permissions.where(portal_id: portal).first_or_initialize
    permission.update_attribute(:roles, roles)
  end

  def role?(role, portal)
    [true, 1, '1', 't', 'T', 'true', 'TRUE'].include?(roles(portal).try(:[], role.to_s))
  end
end

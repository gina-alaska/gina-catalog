module Catalog::EntriesHelper
  def shareable_portals
    current_user.portals.where.not(id: [current_portal.id, current_portal.parent.id]).order(title: :asc).each_with_object([]) do |portal, portals|
      portals << portal if current_user.role?(:data_entry, portal) || current_user.role?(:data_manager, portal)
    end
  end

  def export_value(item)
    item.blank? ? 'none' : item
  end
end

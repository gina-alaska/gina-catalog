module Catalog::EntriesHelper
  def shareable_portals
    portal_ids = [current_portal.id]
    portal_ids += [current_portal.parent.id] if current_portal.parent.present?
    
    current_user.portals.where.not(id: portal_ids).order(title: :asc).each_with_object([]) do |portal, portals|
      portals << portal if current_user.role?(:data_entry, portal) || current_user.role?(:data_manager, portal)
    end
  end

  def export_value(item)
    item.blank? ? 'none' : item
  end
end

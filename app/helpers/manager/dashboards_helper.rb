module Manager::DashboardsHelper
  def link_entry(id)
    entry = Entry.find(id)
    link_to entry.title, catalog_entry_path(entry)
  end
end

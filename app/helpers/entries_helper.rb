module EntriesHelper
  def list_regions(entry)
    entry.regions.pluck(:name).join(', ')
  end
end

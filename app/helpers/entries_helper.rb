module EntriesHelper
  def list_regions(entry)
    entry.regions.pluck(:name).join(', ')
  end

  def list_data_types(entry)
    entry.data_types.pluck(:name).join(', ')
  end
end


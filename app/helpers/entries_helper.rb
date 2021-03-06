module EntriesHelper
  def list_regions(entry)
    entry.regions.pluck(:name).join(', ')
  end

  def list_data_types(entry)
    entry.data_types.pluck(:name).join(', ')
  end

  def limit_select
    [['Limit: 30', 30], ['Limit:100', 100], ['Limit: 500', 500], ['Limit: 1000', 1000], ['Limit: 2000', 2000], ['Limit: 5000', 5000]]
  end

  def format_select
    [%w[HTML html], %w[CSV csv]]
  end
end

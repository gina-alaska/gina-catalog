module AgenciesHelper
  def collection_select_for_agencies(name, selected, special, html_opts = {})
    search = Agency.search do
      with :setup_ids, current_setup.self_and_descendants.pluck(:id)
      paginate per_page:(5000)
      order_by(:name, "asc")
    end

    options = options_from_collection_for_select(search.results, :id, :name_with_acronym, selected)
    html_opts.merge!({ data: {placeholder: 'All Agencies', ui: 'select2'}, multiple: true, :include_blank => true })
    html_opts[:class] ||= 'span12'
    
    if special
      select_tag(name, options, html_opts)
    else
      select_tag(name, options, html_opts)
    end
  end
end

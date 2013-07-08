module AgenciesHelper
  def collection_select_for_agencies(name, selected, special, *css_class)
    search = Agency.search do
      with :setup_ids, current_setup.self_and_descendants.pluck(:id)
      paginate per_page:(5000)
      order_by(:name, "asc")
    end

    css_class = "span12" if css_class.blank?
    options = options_from_collection_for_select(search.results, :id, :name_with_acronym, selected)

    if special
      select_tag(name, options,  class: css_class, data: {placeholder: 'All Agencies', ui: 'select2'}, multiple: true, :include_blank => true)
    else
      select_tag(name, options,  class: css_class, data: {placeholder: 'All Agencies', ui: 'select2'}, :include_blank => true)
    end
  end
end

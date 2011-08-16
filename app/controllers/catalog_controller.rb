class CatalogController < ApplicationController
  caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  caches_action :search

  def show
    @item = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags)
    @item = @item.includes({ :people => [ :addresses, :phone_numbers ] }).find_by_id(params[:id])

    render :layout => false
  end

  def search
#    if(params[:q].nil? or params[:q].empty?)
#      results = sphinx_search('', params[:sort], params[:dir], params[:start], params[:limit])
#    else
#      results = sphinx_search(params[:q], params[:sort], params[:dir], params[:start], params[:limit])
#    end
#    results = Project.search('', :per_page => 3000)
    @results = Catalog.not_archived.published
    @results = @results.includes(:locations, :source_agency, :people, :agencies, :tags)
    @results = @results.limit(params[:limit] || 3000).order('title ASC')

    respond_to do |format|
      format.json
      format.js
    end
  end

  def sphinx_search(query, sort, dir, start, limit = 10000)
    limit = 500 if(!limit)
    page = (start.to_i / limit.to_i) + 1;

    classes = []
    classes << Asset if(params[:data] == 'on')
    classes << Project if(params[:projects] == 'on')

    order = '@weight'
    mode = :expr

    search_params = {
      :classes => classes,
      :include => [:tags, :source_agency, :links, :locations],
      :page => page,
      :per_page => limit.to_i
    }
    if(sort)
      search_params[:order] = "#{sort_field(sort)} #{dir.upcase}"
      search_params[:sort_mode] = :extended
    else
      search_params[:order] = "@weight"
      search_params[:sort_mode] = :expr
    end
    search_params[:match_mode] = :extended
    search_params[:rank_mode] = :bm25

    query = { 'text' => query } if(query.is_a? String)


    if !check_for_items(query, :archived)
      search_params[:with] ||= {}
      search_params[:with][:archived] = false
    else
      search_params[:with] ||= {}
      search_params[:with][:archived] = query[:archived] == "true" ? true : false
    end

    if check_for_items(query, :starts_after, :starts_before)
      search_params[:with] ||= {}
      search_params[:with][:start_date] = time_range(query['starts_after'], query['starts_before'])
    end
    if check_for_items(query, :ends_after, :ends_before)
      search_params[:with] ||= {}
      search_params[:with][:end_date] = time_range(query['ends_after'], query['ends_before'])
    end
    if check_for_items(query, :created_after, :created_before)
      search_params[:with] ||= {}
      search_params[:with][:created_at] = time_range(query['created_after'], query['created_before'])
    end
    if check_for_items(query, :updated_after, :updated_before)
      search_params[:with] ||= {}
      search_params[:with][:updated_at] = time_range(query['updated_after'], query['updated_before'])
    end
    if check_for_items(query, :gcmd_themes)
      search_params[:with_all] ||= {}
      search_params[:with_all][:gcmd_theme_ids] = query['gcmd_themes'].collect { |v| v.to_i }
    end
    %w{source_agency_id owner_id agency_ids}.each do |item|
      if check_for_items(query, item.to_sym)
        search_params[:with] ||= {}
        search_params[:with][item.to_sym] = query[item.to_s].to_i
      end
    end
    %w{locations contacts status}.each do |item|
      if check_for_items(query, item.to_sym)
        search_params[:conditions] ||= {}
        search_params[:conditions][item.to_sym] = query[item.to_s]
      end
    end
    if check_for_items(query, :contacts)
      search_params[:conditions] ||= {}
      search_params[:conditions][:primary_contact] = query[:contacts]
    end

    logger.info(search_params.inspect)

    return ThinkingSphinx.search(query['text'], search_params)
  end

  protected

  def sort_field(field)
    attributes = %w{created_at updated_at start_date end_date start_date_year end_date_year}

    return field if attributes.include? field
    return "#{field}_sort"
  end

  def time_range(after, before)
    return false if after.empty? and before.empty?

    if after.empty?
      begintime = Time.parse('1970.01.01')
    else
      begintime = Time.parse(after)
    end
    if before.empty?
      endtime = Time.parse('2032.01.01')
    else
      endtime = Time.parse(before)
    end

    return begintime..endtime
  end

  def check_for_items(items, *fields)
    fields.each do |f|
      if items.include?(f.to_sym)
        items[f.to_s].reject! { |x| x == '' } if items[f.to_s].is_a? Array

        return true unless items[f.to_s].empty?
      end
    end

    return false
  end

  def search_object
    assets = (params.include? :data and params[:data] == 'on' ? true : false)
    projects = (params.include? :projects and params[:projects] == 'on' ? true : false)

    if assets
      if projects
        return ThinkingSphinx
      else
        return Asset
      end
    elsif projects
      return Project
    else
      return ThinkingSphinx
    end
  end
end

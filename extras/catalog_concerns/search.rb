module CatalogConcerns
  module Search
    extend ActiveSupport::Concern
    
    SORT_FIELDS = ["title", "type", "status", "agency", "relevance", "created_at", "updated_at", "source_agency_acronym"]

    module InstanceMethods
      def search_params(search={})
        search ||= {}
        search.symbolize_keys
          
        if search.include? :collection_ids
          search[:collection_ids] = search[:collection_ids].split(',') unless search[:collection_ids].is_a?(Array)
          search[:collection_ids] = search[:collection_ids].map(&:to_i) 
        end
        search[:collection_ids] ||= []

        search[:field] = "relevance" unless SORT_FIELDS.include?(search[:field])
        search[:direction] = "ascending" unless %w{ascending descending}.include?(search[:direction])
      
        if (search['q'].nil? or search['q'].blank?) and (search['field'].blank? or search['direction'].blank?)
          search[:order_by] = "title_sort-ascending"
        else
          search.delete(:order_by)
        end
        
        unless search[:field] == "relevance"
          search[:order_by] ||= "#{search[:field]}_sort-#{search[:direction]}"
        end
            
        unless current_user and current_member.can_manage_catalog?
          search[:published_only] = true
        end
        
        return search
      end

      def solr_search(search, page=1, limit=10000, facet_list = false)    
        if search.nil? or search.keys.empty?
          return [] 
        end

        table_includes = {
          :repo => [], :locations => [], :download_urls => []
          # :repo => [], :locations => [], :download_urls => [], :owner_setup => [], :setups => [], :source_agency => []
          # :tags => [], :locations => [], :agencies => [], :source_agency => [], :funding_agency => [], :links => [], 
          # :primary_contact => [:phone_numbers], :people => [:phone_numbers], :data_source => [], :geokeywords => [], :catalog_collections => [], 
          # :repo => [], :data_types => [], :collections => []
        }
  
        catalog_ids = search[:ids] unless search[:ids].nil? or search[:ids].empty?
    
        if !catalog_ids and search[:bbox] and !search[:bbox].empty?
          # catalog_ids = []
          # catalog_ids += Catalog.geokeyword_intersects(bbox).pluck('catalog.id').uniq
          catalog_ids = Catalog.location_intersects(search[:bbox]).pluck(:id)
          catalog_ids.uniq!
        end

        if search[:order_by]
          field, direction = search[:order_by].split("-")
          direction ||= :asc
        end
        
        Catalog.search(include: table_includes) do
          # adjust_solr_params do |params|
          #   # Force solar to do an 'OR'ish search, at least 1 "optional" word is required in each  
          #   # ocean marine sea    ~> ocean OR marine OR sea
          #   # ocean marine +sea   ~> (ocean AND sea) OR (marine AND sea)
          #   # ocean +marine +sea  ~> ocean AND marine AND sea
          #   params[:mm] = "1"
          #   params[:ps] = 1
          #   params[:pf] = [:title, :description]
          # end

          fulltext search[:q] if search[:q].present?
          
          any_of do
            with :owner_setup_id, current_setup.id 
            unless search[:editable] == 'true'
              with :setup_ids, current_setup.self_and_descendants.pluck(:id)
            end
          end
          
          with :active, true          
          with :sds, true if search[:sds] == 'true'
          
          # unless search[:editable] == 'true' or search[:sds] == 'true'
          #   with :setup_ids, current_setup.id
          # end

          with :id, catalog_ids unless catalog_ids.nil? or catalog_ids.empty?
          with :status, search[:status] if search[:status].present?
          with :long_term_monitoring, ((search[:long_term_monitoring].to_i > 0) ? true : false) if search.include? :long_term_monitoring
          with :archived_at_year, nil unless search[:archived]
          
          if search[:type].present?
            if search[:type] == 'Data'
              #work around for legacy data
              with :record_type, 'Asset' 
            else
              with :record_type, search[:type] 
            end
          end
          with :agency_ids, search[:agency_ids] if search[:agency_ids].present?
          with :source_agency_id, search[:source_agency_id] if search[:source_agency_id].present?
          with :funding_agency_id, search[:funding_agency_id] if search[:funding_agency_id].present?
          with :iso_topic_ids, search[:iso_topic_ids] if search[:iso_topic_ids].present?
          with :collection_ids, search[:collection_id] if search[:collection_id].present?
          if search[:collection_ids].present?
            all_of do
              search[:collection_ids].each do |id|
                with :collection_ids, id
              end
            end
          end
          with :primary_contact_id, search[:primary_contact_id] if search[:primary_contact_id].present?
          with :contact_ids, search[:contact_ids] if search[:contact_ids].present?
          with :owner_setup_id, search[:owner_setup_id] if search[:owner_setup_id].present?
          with :geokeywords_name, search[:region] if search[:region].present?
          with :data_types, search[:data_types] if search[:data_types].present?
          with :agency_types, search[:agency_types] if search[:agency_types].present?
  
          with(:published_at).less_than(Time.zone.now) if search[:published_only]
          if search[:unpublished] == 'true'
            any_of do
              with :published_at, nil
              with(:published_at).greater_than(Time.zone.now)
            end
          end
      
          with(:start_date_year).greater_than(search[:start_date_after]) if search[:start_date_after].present?

          with(:start_date_year).less_than(search[:start_date_before]) if search[:start_date_before].present?

          with(:end_date_year).greater_than(search[:end_date_after]) if search[:end_date_after].present?
      
          with(:end_date_year).less_than(search[:end_date_before]) if search[:end_date_before].present?

          paginate per_page:(limit), page:(page)
      
          if facet_list
            facet facet_list
          end
      
          order_by(field, direction) if field and direction
        end
      end
    end
  end
end
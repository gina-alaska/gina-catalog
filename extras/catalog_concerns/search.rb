module CatalogConcerns
  module Search
    extend ActiveSupport::Concern
    
    module InstanceMethods
      def solr_search(search, page=1, limit=10000, manager=false)    
        return [] if search.nil? or search.keys.empty?
    
        table_includes = {
          :tags => [], :locations => [], :agencies => [], :source_agency => [], :funding_agency => [], :links => [], 
          :primary_contact => [:phone_numbers], :people => [:phone_numbers], :data_source => [], :geokeywords => [], :catalog_collections => [], 
          :repo => [], :data_types => []
        }
  
        catalog_ids = search[:ids] unless search[:ids].nil? or search[:ids].empty?
    
        if(!catalog_ids and search[:bbox])
          # catalog_ids = []
          # catalog_ids += Catalog.geokeyword_intersects(bbox).pluck('catalog.id').uniq
          catalog_ids = Catalog.location_intersects(search[:bbox]).select('distinct catalog.id').collect(&:id)
          catalog_ids.uniq!
        end

        if search[:order_by]
          field, direction = search[:order_by].split("-");
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

          fulltext search[:q]
          
          with :owner_setup_id, current_setup.id if search[:editable] == 'true'
          with :use_agreement_id, current_setup.id if search[:sds] == 'true'
          
          unless search[:editable] == 'true' or search[:sds] == 'true'
            with :setup_ids, current_setup.id
          end

          with :id, catalog_ids unless catalog_ids.nil? or catalog_ids.empty?
          with :status, search[:status] if search[:status].present?
          with :long_term_monitoring, ((search[:long_term_monitoring].to_i > 0) ? true : false) if search.include? :long_term_monitoring
          with :archived_at_year, nil unless search[:archived]
          with :record_type, search[:type] if search[:type].present?
          with :agency_ids, search[:agency_ids] if search[:agency_ids].present?
          with :source_agency_id, search[:source_agency_id] if search[:source_agency_id].present?
          with :funding_agency_id, search[:funding_agency_id] if search[:funding_agency_id].present?
          with :iso_topic_ids, search[:iso_topic_ids] if search[:iso_topic_ids].present?
          with :catalog_collection_ids, search[:catalog_collection_ids] if search[:catalog_collection_ids].present?
          with :primary_contact_id, search[:primary_contact_id] if search[:primary_contact_id].present?
          with :contact_ids, search[:contact_ids] if search[:contact_ids].present?
          with :geokeywords_name, search[:region] if search[:region].present?
          with :data_types, search[:data_types] if search[:data_types].present?
          with :agency_types, search[:agency_types] if search[:agency_types].present?
  
          with(:published_at).less_than(Time.zone.now) if search[:published_only]
      
          with(:start_date_year).greater_than(search[:start_date_after]) if search[:start_date_after].present?

          with(:start_date_year).less_than(search[:start_date_before]) if search[:start_date_before].present?

          with(:end_date_year).greater_than(search[:end_date_after]) if search[:end_date_after].present?
      
          with(:end_date_year).less_than(search[:end_date_before]) if search[:end_date_before].present?

          paginate per_page:(limit), page:(page)
      
          order_by(field, direction) if field and direction
        end
      end
    end
  end
end
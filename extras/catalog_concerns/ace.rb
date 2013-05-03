module CatalogConcerns
  module Ace
    def init_ace_editor
      search = params[:ace] || {}
      if search.include?(:image)
        solr = Image.search do
          fulltext search[:image]
        end
        @images = solr.results
      else
        @images = current_setup.images.order('title ASC')
      end
      
      @ace_search_params = search
    end
  end
end
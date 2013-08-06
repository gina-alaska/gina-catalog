module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern
    
    module InstanceMethods 
      def import_from_fgcd url
        #Fetch the record
        metadata = FGDC.new(url)
        

        self.title = metadata.title
        self.description = metadata.abstract
        self.tags = metadata.keywords.collect{|k| Tag.first_or_initialize(k)}
        self.locations.first_or_initialize.geom = metadata.bounds
        #TODO: contacts, agencies, links
      end
    end
  end
end
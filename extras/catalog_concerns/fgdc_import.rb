module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern
    
    module InstanceMethods 
      def import_from_fgcd url
        #Fetch the record
        metadata = FGDC.new(url)
        

        self.title = metadata.title
        self.description = metadata.abstract
        self.tags = metadata.keywords.collect{|k| Tag.where(text: k).first_or_initialize}
        self.locations.first_or_initialize.geom = metadata.bounds
        self.links = metadata.links.collect do |l|
          self.links.where(url: l).first_or_initialize
        end
        
        if metadata.primary_contact.nil?
          self.primary_contact_id = nil
        else
          self.primary_contact = Person.where(metadata.primary_contact).first_or_initialize
        end
        
        # self.agencies = metadata.agencies.collect do |a|
        #   self.agencies.where(a).first_or_initialize
        # end
        #TODO: contacts, agencies, links
      end
    end
  end
end
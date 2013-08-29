module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern
    
    module InstanceMethods 
      def import_from_fgcd url
        import_errors = {}
        
        #Fetch the record
        metadata = FGDC.new(url)
        

        self.title = metadata.title
        self.description = metadata.abstract
        self.type = "Asset"
        self.tags = metadata.keywords.collect{|k| Tag.where(text: k).first_or_initialize}
        self.locations = [self.locations.first_or_initialize(geom: metadata.bounds, name: 'Record Bounds')]
        self.links = metadata.onlinks.collect do |l|
          self.links.where(url: l).first_or_initialize(display_text: l, category: "Website")
          self.links.where(url: url).first_or_initialize(display_text: 'Metadata', categroy: 'Metadata')
        end
        self.start_date = begin
          DateTime.parse(metadata.start_date) unless metadata.start_date.empty?
        rescue
          import_errors[:start_date] = metadata.start_date unless metadata.start_date.empty?
        end
        self.end_date = begin
          DateTime.parse(metadata.end_date) unless metadata.end_date.empty?
        rescue
          import_errors[:end_date] = metadata.end_date unless metadata.end_date.empty?
        end
        
        
        if metadata.primary_contact.nil?
          self.primary_contact_id = nil
        else
          self.primary_contact = Person.where(metadata.primary_contact).first_or_initialize
        end
        
        agency = Agency.where(name: metadata.source_agency).first
        if agency.nil?
          import_errors[:agencies] ||= []
          import_errors[:agencies] << metadata.source_agency
        else
          self.source_agency = agency        
        end

        
        import_errors
      end
    end
  end
end
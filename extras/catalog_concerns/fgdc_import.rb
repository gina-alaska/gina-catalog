module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern
    
    module InstanceMethods 
      def fgdc_link(url, category)
        attrs = { url: url, display_text: url, category: category }
        if link = self.links.where(url: url).first
          link.update_attributes(attrs)
          link
        else
          self.links.build(attrs)
        end
      end
      
      def fgdc_download_url(url)
        attrs = { url: url }
        if link = self.download_urls.where(url: url).first
          link.update_attributes(attrs)
          link
        else
          self.download_urls.build(attrs)
        end
      end
      
      def import_from_fgcd url
        import_errors = {}

        #Fetch the record
        metadata = FGDC.new(url)
        
        self.title = metadata.title
        self.description = metadata.abstract

        case metadata.status.chomp.strip.downcase
        when 'complete'
          self.status = "Complete"
        when 'in work'
          self.status = "Ongoing"
        when 'ongoing'
          self.status = "Ongoing"
        else
          self.status = "Unknown"
          puts import_errors[:status] = "Unknown status: #{metadata.status}"
        end
        
        self.type = "Asset"
        # self.tags = metadata.keywords.collect{|k| Tag.where(text: k).first_or_initialize}
        
        self.tags = metadata.keywords.collect.to_a.join(', ')
        
        loc = self.locations.where(geom: metadata.bounds).first_or_initialize(name: 'Record Bounds')
        loc.update_attributes(name: 'Record Bounds')
        
        # self.locations = [self.locations.first_or_initialize(geom: metadata.bounds, name: 'Record Bounds')]
        # self.links = metadata.onlinks.collect do |l|
        #   self.links.where(url: l).first_or_initialize(display_text: l, category: "Website")
        # end
        # 
        # self.links.where(url: url).first_or_initialize(display_text: 'Metadata', category: 'Metadata')
        metadata.onlinks.each do |l|
          case l.split('.').last
          when 'zip'
            self.download_urls << fgdc_download_url(l)
            self.links << fgdc_link(l, 'Download')
          else
            self.links << fgdc_link(l, 'Website')
          end
        end
        self.links << fgdc_link(url, 'Metadata')
        
        unless metadata.start_date.empty?
          self.start_date = begin
            DateTime.parse(metadata.start_date)
          rescue => e
            begin
              DateTime.strptime(metadata.start_date, "%Y").beginning_of_year
            rescue => e
              import_errors[:start_date] = metadata.start_date
            end
          end
        end

        unless metadata.end_date.empty?
          self.end_date = begin
            DateTime.parse(metadata.end_date)
          rescue => e
            begin
              DateTime.strptime(metadata.end_date, "%Y").end_of_year
            rescue => e
              import_errors[:end_date] = metadata.end_date 
            end
          end
        end
        
        if metadata.primary_contact.nil?
          self.primary_contact_id = nil
        else
          self.primary_contact = Person.where(metadata.primary_contact).first_or_initialize
        end
        
        agency = Agency.where(name: metadata.source_agency).first
        agency ||= Alias.where(text: metadata.source_agency, aliasable_type: 'Agency').first.try(:aliasable)
        if agency.nil?
          import_errors[:agencies] ||= []
          import_errors[:agencies] << metadata.source_agency
        else
          self.source_agency = agency        
        end

        
        import_errors
      rescue => e
        puts "Unhandled error #{e}"
        raise
      end
    end
  end
end
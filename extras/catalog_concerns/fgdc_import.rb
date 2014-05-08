module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern

    module InstanceMethods
      def fgdc_agency(name)
        return nil if name.nil?
        
        name = CGI.unescapeHTML(name)
        
        agency = Agency.where(name: name).first
        agency ||= Alias.where(text: name, aliasable_type: 'Agency').first.try(:aliasable)

        return agency
      end
      
      def find_contact(contact_info)
        return nil if contact_info.nil?
        
        contact = nil
        
        if contact_info[:email].present?
          contact = Person.where(first_name: contact_info[:first_name], last_name: contact_info[:last_name], email: contact_info[:email]).first
        elsif contact_info[:job_title].present?
          contact = Person.where(first_name: contact_info[:first_name], last_name: contact_info[:last_name], job_title: contact_info[:job_title]).first
        end
        
        contact
      end

      def fgdc_contact(contact_info)
        return nil if contact_info.nil?

        phone = contact_info.delete(:phone_numbers)

        contact = find_contact(contact_info)        
        contact ||= Person.create(contact_info)

        contact.setups << self.owner_setup unless contact.setups.include?(self.owner_setup)

        if contact.phone_numbers.where(name: 'work').empty?
          work_number = contact.phone_numbers.create(name: 'work', digits: phone[:work])
        end

        contact
      end

      def fgdc_link(url, default_category = 'Website', display_text = nil)
        # default to url if not given
        display_text ||= url
        
        case url.split('/').last.try(:downcase)
        when 'mapserver'
          category = 'Map Service'
          # Add some other related links for this
          fgdc_link(url + '?f=jsapi', 'Map Service', 'ArcGIS JS Map')
          fgdc_link(url + '?f=lyr', 'Map Service', 'ArcMAP Layer')
          fgdc_link(url + '/kml/mapImage.kmz', 'Map Service', 'Google Earth')
        else
          category = default_category
        end

        attrs = { url: url, display_text: display_text, category: category }
        if link = self.links.where(url: url).first
          link.update_attributes(attrs)
          link
        else
          self.links.build(attrs)
        end
      end
      
      def link_template(url, default_category = 'Website',  default_text = nil)
        url = url.gsub('{{uuid}}', self.uuid)
        
        fgdc_link(url, default_category, default_text)
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

      def import_from_fgdc(url, import)
        import_errors = {}

        #Fetch the record
        metadata = FGDC.new(url)

        self.source_url = url
        self.title = CGI.unescapeHTML(metadata.title)
        self.description = CGI.unescapeHTML(metadata.abstract)
        self.status = metadata.status

        self.type = "Asset"
        # self.tags = metadata.keywords.collect{|k| Tag.where(text: k).first_or_initialize}

        self.tags = metadata.keywords

        loc = self.locations.where(geom: metadata.bounds).first_or_initialize(name: 'Record Bounds')
        loc.update_attributes(name: 'Record Bounds')

        link_template(import.url_template, 'Website', import.url_description)
        fgdc_link(url, 'Metadata', 'Source')
        
        metadata.onlinks.each do |l|
          next if l.downcase == 'none'

          if %q{ zip pdf }.include?(l.split('.').last.try(:downcase))
            fgdc_download_url(l)
          else
            fgdc_link(l, 'Website')
          end

        end

        self.start_date = metadata.start_date
        self.end_date = metadata.end_date

        if pc = find_contact(metadata.citation_contact)
          # if we find a contact from the citation info use that as primary
          oc = fgdc_contact(metadata.alt_primary_contact)
          self.people << oc unless oc.nil? or self.people.include?(oc) or pc == oc
        else
          # otherwise pull from the metadata point of contact
          pc = fgdc_contact(metadata.alt_primary_contact)
        end
        
        if pc.nil?
          self.primary_contact = nil
        else
          self.primary_contact = pc
        end

        metadata.other_contacts.each do |contact|
          c = fgdc_contact(contact)
          next if self.people.include?(c) or self.primary_contact == c

          self.people << c
        end

        missing_agencies = []

        primary_agency = fgdc_agency(metadata.primary_agency.first)

        unless primary_agency.nil?
          missing_agencies << CGI.unescapeHTML(metadata.primary_agency.first) unless metadata.primary_agency.first.nil?
        else
          self.source_agency = primary_agency unless self.source_agency == primary_agency
        end

        metadata.agencies.each do |agency_name|
          next if agency_name.nil? or agency_name.empty?
          agency = fgdc_agency(agency_name)

          if agency.nil?
            missing_agencies << CGI.unescapeHTML(agency_name)
          else
            self.agencies << agency unless self.agencies.include?(agency)
          end
        end

        missing_agencies = missing_agencies.uniq.compact
        unless missing_agencies.empty?
          self.activity_logs.create_agency_import_error(message: "Could not find the following agencies: #{missing_agencies.join(', ')}", missing_agencies: missing_agencies)
        end
      rescue => e
        puts "Unhandled error #{e}"
        puts e.backtrace

        self.activity_logs.create_import_error(message: "Unhandled error #{e}, while trying to import the record")
        raise
      end

      alias_method :import_from_fgcd, :import_from_fgdc
    end
  end
end

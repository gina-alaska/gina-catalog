module CatalogConcerns
  module FgdcImport
    extend ActiveSupport::Concern

    module InstanceMethods
      def fgdc_agency(name)
        agency = Agency.where(name: name).first
        agency ||= Alias.where(text: name, aliasable_type: 'Agency').first.try(:aliasable)

        return agency
      end

      def fgdc_contact(contact_info)
        return nil if contact_info.nil?

        phone = contact_info.delete(:phone_numbers)

        # self.primary_contact = Person.where(metadata.primary_contact).first_or_initialize
        contact = Person.where(first_name: contact_info[:first_name], last_name: contact_info[:last_name], email: contact_info[:email]).first
        if contact.nil?
          contact = Person.create(contact_info)
        end
        contact.setups << self.owner_setup unless contact.setups.include?(self.owner_setup)

        if contact.phone_numbers.where(name: 'work').empty?
          work_number = contact.phone_numbers.create(name: 'work', digits: phone[:work])
        end

        contact
      end

      def fgdc_link(url, default_category = 'Website')
        case url.split('/').last.try(:downcase)
        when 'mapserver'
          category = 'Map Service'
        else
          category = default_category
        end

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

      def import_from_fgdc url
        import_errors = {}

        #Fetch the record
        metadata = FGDC.new(url)

        self.source_url = url
        self.title = metadata.title
        self.description = metadata.abstract
        self.status = metadata.status

        self.type = "Asset"
        # self.tags = metadata.keywords.collect{|k| Tag.where(text: k).first_or_initialize}

        self.tags = metadata.keywords

        loc = self.locations.where(geom: metadata.bounds).first_or_initialize(name: 'Record Bounds')
        loc.update_attributes(name: 'Record Bounds')

        # self.locations = [self.locations.first_or_initialize(geom: metadata.bounds, name: 'Record Bounds')]
        # self.links = metadata.onlinks.collect do |l|
        #   self.links.where(url: l).first_or_initialize(display_text: l, category: "Website")
        # end
        #
        # self.links.where(url: url).first_or_initialize(display_text: 'Metadata', category: 'Metadata')
        metadata.onlinks.each do |l|
          next if l.downcase == 'none'

          if %q{ zip pdf }.include?(l.split('.').last.try(:downcase))
            self.download_urls << fgdc_download_url(l)
            # self.links << fgdc_link(l, 'Download')
          else
            self.links << fgdc_link(l, 'Website')
          end

        end
        self.links << fgdc_link(url, 'Metadata')

        self.start_date = metadata.start_date
        self.end_date = metadata.end_date

        pc = fgdc_contact(metadata.primary_contact)
        if pc.nil?
          self.primary_contact = nil
        else
          self.primary_contact = pc
        end

        metadata.other_contacts.each do |contact|
          c = fgdc_contact(contact)
          next if self.people.include?(c) or self.primary_contact == c

          puts c.inspect
          self.people << c
        end

        missing_agencies ||= []

        primary_agency = fgdc_agency(metadata.primary_agency.first)

        if primary_agency.nil?
          missing_agencies << metadata.primary_agency.first
        else
          self.source_agency = primary_agency unless self.source_agency == primary_agency
        end

        metadata.agencies.each do |agency_name|
          next if agency_name.nil? or agency_name.empty?
          agency = fgdc_agency(agency_name)

          if agency.nil?
            missing_agencies << agency_name
          else
            self.agencies << agency unless self.agencies.include?(agency)
          end
        end

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

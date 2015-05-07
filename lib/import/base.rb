module Import
  class Base
    def self.fetch
      fail 'Please define a fetch method'
    end

    def add_simple_fields(fields, model, json = {})
      fields.each do |field|
        model.send("#{field}=", json[field]) if json[field].present? && model.send(field).blank?
      end
    end

    def add_other_orgs(record, agencies)
      return if agencies.blank?

      agencies.each do |json|
        org = ::Organization.where(name: json['name']).first
        record.organizations << org unless org.nil? || record.organizations.include?(org)
      end
    end

    def find_org(json)
      return if json.nil?

      ::Organization.where(name: json['name']).first
    end

    def find_iso_topic(json)
      return if json.nil?

      ::IsoTopic.where(iso_theme_code: json['iso_theme_code']).first      
    end
    
    def find_collection(json)
      return if json.nil?
      
      item = ImportItem.collections.oid(json['id']).first
      item.try(:importable)
    end

    def find_use_agreement(json)
      return if json.nil?
      
      item = ImportItem.use_agreements.oid(json['id']).first
      item.try(:importable)
    end

    def find_contact(contact)
      return if contact.nil?

      ImportItem.contacts.oid(contact['id']).first.try(:importable)
    end
  end
end

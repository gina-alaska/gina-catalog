require 'import/base'

module Import
  class Contact < Base
    def self.fetch
      contact = ::Import::Contact.new

      Client.paged_results 'Contacts', Client.contacts_url do |json|
        contact.create(json)
      end
    end

    def create(json = {})
      import = ImportItem.contacts.oid(json['id']).first_or_initialize
      import.importable ||= ::Contact.where(name: json['name']).first_or_initialize

      simple_fields = %w(name email job_title)

      add_simple_fields(simple_fields, import.importable, json)

      import.save
      import.importable.save
      import
    end
  end
end

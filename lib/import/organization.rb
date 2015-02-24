require 'import/base'

module Import
  class Organization < Base
    def self.fetch
      organizations = Organization.new

      Client.results('Agencies', Client.agencies_url) do |json|
        organizations.create(json)
      end
    end

    def create(json)
      org = ::Organization.where(name: json['name']).first_or_create

      fields = %w(acronym category description url)
      add_simple_fields(fields, org, json)

      org.logo_url = json['logo_url'] if org.logo.nil?
      org.save
    end
  end
end

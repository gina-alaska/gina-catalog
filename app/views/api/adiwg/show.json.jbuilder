# template for building the adiwg api json output
# part of gLynx

# mdJson version
json.version do
  json.name 'mdJson'
  json.version '1.1.0'
end # version

# dummy array to use when there needs to be an length 1 array
# of hash objects
dummy = ['1']

# list of contacts, orgs, and GINA(for metadata support)
# primary contacts are placed before otehr contacts in list
all_contacts = @entry.primary_contacts + @entry.other_contacts +
               @entry.organizations + ['gina']

# list of all contact ids
#    1st item will be used as point of contact(POC) when needed.
# If there are primary contactes the first one will be used as POC.
# otherwise the first contact or organization avaialbe defaulting to
# GINA_support
id_list = []

## array of contacts, to be referenced in other parts of metadata
json.contact(all_contacts) do |contact|
  if contact.is_a? Contact
    json.contactId 'contact_' + contact.id.to_s
    id_list += ['contact_' + contact.id.to_s]
    json.individualName contact.name

    json.positionName contact.job_title
    json.onlineResource(dummy) do |online|
      ## not stored with gLinx contact entries
    end
    # ~ json.contactInstructions ''
    json.phoneBook(dummy) do |_phone|
      json.phoneName contact.name
      json.phoneNumber contact.phone_number
    end

    json.address do
      json.electronicMailAddress [contact.email]
    end # address

  elsif contact.is_a? Organization
    json.contactId 'org_' + contact.id.to_s
    id_list += ['org_' + contact.id.to_s]
    json.organizationName contact.name

    json.onlineResource(dummy) do |_online|
      contact_uri = URI(contact.url)
      url = contact.url
      if contact_uri.scheme.nil?
        url = 'http://' + url
        contact_uri.scheme = 'http'
      end
      json.uri url
      json.protocol contact_uri.scheme
    end # onlineResource

  else
    json.contactId 'GINA_support'
    id_list += ['GINA_support']
    json.organizationName 'GINA'
    json.address do
      json.electronicMailAddress ['support@gina.alaska.edu']
    end # address

  end # if
end # contact

# metadata
json.metadata do
  # information about metadata itself
  json.metadataInfo do
    # ~ json.metadataIdentifier do
    # ~ json.identifier ''
    # ~ json.type ''
    # ~ end #metadataIdentifier

    # ~ json.parentMetadata do
    # ~ json.title ''
    # ~ json.alternativeTitle ''
    # ~ json.date(dummy) do |date|
    # ~ json.date '0000-00-00'
    # ~ json.dateType ''
    # ~ end # Date

    # ~ json.edition ''
    # ~ json.responsibleParty(dummy) do |party|
    # ~ json.contactId ''
    # ~ json.role ''
    # ~ end #responsibleParty

    # ~ json.presentationForm ['']
    # ~ json.identifier(dummy) do |id|
    # ~ json.identifier ''
    # ~ json.type ''
    # ~ end #identifier

    # ~ json.onlineResource(dummy) do |olr|
    # ~ json.uri 'http://thisisanexample.com'
    # ~ json.protocol ''
    # ~ json.name ''
    # ~ json.description ''
    # ~ json.function ''
    # ~ end #onlineResource

    # ~ end #parentMetadata

    json.metadataContact(dummy) do |_contact|
      json.contactId 'GINA_support'
      json.role 'metadata support'
    end # metadatContact

    json.metadataCreationDate @entry.created_at.to_date.to_s
    json.metadataLastUpdate @entry.updated_at.to_date.to_s
    json.metadataCharacterSet 'utf8'
    json.metadataLocale(dummy) do |_locale|
      json.language 'EN'
      json.country 'US'
      json.characterSet 'utf8'
    end # metadataLocale

    # ~ json.metadataUri 'http://thisisanexample.com'
    # ~ json.metadataStatus ''
    # ~ json.metadataMaintenance do
    # ~ json.maintenanceFrequency ''
    # ~ json.maintenanceNote ['']
    # ~ json.maintenanceContact(dummy) do |contact|
    # ~ json.contactId ''
    # ~ json.role ''
    # ~ end #maintenanceContact

    # ~ end #metadataMaintenance
  end # metadataInfo

  # metadata on resource
  json.resourceInfo do
    json.resourceType @entry.entry_type_name.downcase
    json.citation do
      json.title @entry.title
      # ~ json.alteranteTitle 'a'
      json.date(dummy) do |_date|
        json.date @entry.updated_at.to_date.to_s
        json.dateType 'updated'
      end # Date

      # ~ json.edition ''
      json.responsibleParty(dummy) do |_party|
        json.contactId id_list.first
        json.role 'primary contact'
      end # responsibleParty

      # ~ json.presentationForm ['']
      # ~ json.identifier(dummy) do |id|
      # ~ json.identifier ''
      # ~ json.type 'abcd'
      # ~ json.authority do
      # ~ json.title ''
      # ~ json.alteranteTitle ''
      # ~ json.date(dummy) do |date|
      # ~ json.date '0000-00-00'
      # ~ json.dateType ''
      # ~ end # Date
      # ~ json.responsibleParty(dummy) do |party|
      # ~ json.contactId ''
      # ~ json.role ''
      # ~ end #responsibleParty
      # ~ json.onlineResource(dummy) do |olr|
      # ~ json.uri 'http://thisisanexample.com'
      # ~ json.protocol ''
      # ~ json.name ''
      # ~ json.description ''
      # ~ json.function ''
      # ~ end #onlineResource

      # ~ end #authority

      # ~ end #identifier

      # ~ json.onlineResource(dummy) do |olr|
      # ~ json.uri 'http://thisisanexample.com'
      # ~ json.protocol ''
      # ~ json.name ''
      # ~ json.description ''
      # ~ json.function ''
      # ~ end #onlineResource
    end # citation

    json.resourceTimePeriod do
      # ~ json.description ''
      json.beginPosition @entry.start_date if @entry.start_date.present?
      json.endPosition @entry.end_date if @entry.end_date.present?
    end # resourceTimePeriod

    json.pointOfContact(dummy) do |_contact|
      json.contactId id_list.first
      json.role 'primary contact'
    end # pointOfContact

    json.abstract @entry.description
    # ~ json.shortAbstract ''
    json.status @entry.status
    # ~ json.hasMapLocation true
    # ~ json.hasDataAvailable true
    json.language ['EN']
    # ~ json.characterSet ['']
    json.locale(dummy) do |_locale|
      json.language 'EN'
      json.country 'US'
      json.characterSet 'utf8'
    end # locale
    # ~ json.purpose ''
    # ~ json.credit ['']
    # ~ json.topicCategory ['']
    # ~ json.environmentDescription ''
    # ~ json.resourceNativeFormat

    keywords = @entry.iso_topics + @entry.tags

    json.keyword(keywords) do |kw|
      if kw.is_a? IsoTopic
        json.keywordType 'ISO topic'
        json.keyword [kw.name, kw.long_name]
      else
        json.keywordType 'tag'
        json.keyword [kw.name]
      end
    end
  end # resourceInfo
end

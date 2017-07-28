json.version do
  json.name 'mdJson'
  json.version '1.1.0'
end

dummy = ['1']
json.contact(dummy) do |contact|
    json.contactId contact
    json.individualName contact
    json.organizationName ''
    json.positionName ''
    json.onlineResource(dummy) do |online|
    end
    json.contactInstructions ''
    json.phoneBook(dummy) do |phone|
	  json.phoneName ''
	  json.phoneNumber '999-999-9999'
    end
    json.address do
      ## stuff goes here
    end
    #json.isOrganization false
end



#json.metadata do
#  json.resourceInfo 'info'
  
#end
#json.title @entry.title


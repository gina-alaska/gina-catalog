# mdJson version
json.version do
  json.name 'mdJson'
  json.version '1.1.0'
end #version

dummy = ['1']

## array of contacts, to be referenced in other parts of metadata
json.contact(@entry.contacts) do |contact|
    json.contactId contact.id.to_s
    json.individualName contact.name
    json.organizationName ''
    json.positionName contact.job_title
    json.onlineResource(dummy) do |online|
    end
    json.contactInstructions ''
    json.phoneBook(dummy) do |phone|
	  json.phoneName contact.name
	  json.phoneNumber contact.phone_number
    end
    json.address do
      ## stuff goes here
    end
    #json.isOrganization false
end #contact

json.metadata do
  json.metadataInfo do
	#~ json.metadataIdentifier do
	  #~ json.identifier ''
	  #~ json.type ''
	#~ end #metadataIdentifier
	
	#~ json.parentMetadata do
	  #~ json.title ''
	  #~ json.alternativeTitle ''
	  #~ json.date(dummy) do |date|
		#~ json.date '0000-00-00'
	    #~ json.dateType ''
	  #~ end # Date
	  
	  #~ json.edition ''
	  #~ json.responsibleParty(dummy) do |party|
	    #~ json.contactId ''
	    #~ json.role ''
	  #~ end #responsibleParty
	  
	  #~ json.presentationForm ['']
	  #~ json.identifier(dummy) do |id|
		#~ json.identifier ''
	    #~ json.type ''
	  #~ end #identifier
	  
	  #~ json.onlineResource(dummy) do |olr|
	    #~ json.uri 'http://thisisanexample.com'
	    #~ json.protocol ''
	    #~ json.name ''
	    #~ json.description ''
	    #~ json.function ''
	  #~ end #onlineResource
	  
	#~ end #parentMetadata
	
	json.metadataContact(dummy) do |contact|
	  json.contactId '2'
	  json.role 'person'
	end #metadatContact
	
	json.metadataCreationDate '0000-00-00'
	#~ json.metadataLastUpdate '0000-00-00'
	#~ json.metadataCharacterSet 'utf8'
	#~ json.metadataLocale(dummy) do |locale|
	  #~ json.language ''
	  #~ json.country ''
	  #~ json.characterSet ''
	#~ end #metadataLocale
	
	#~ json.metadataUri 'http://thisisanexample.com'
	#~ json.metadataStatus ''
	#~ json.metadataMaintenance do
	  #~ json.maintenanceFrequency ''
	  #~ json.maintenanceNote ['']
	  #~ json.maintenanceContact(dummy) do |contact|
	    #~ json.contactId ''
	    #~ json.role ''
	  #~ end #maintenanceContact
	  
	#~ end #metadataMaintenance
	
  end #metadataInfo
  json.resourceInfo do
	json.resourceType ''
	json.citation do 
	  json.title 'abcd'
	  #~ json.alteranteTitle 'a'
	  json.date(dummy) do |date|
		json.date '0000-00-00'
	    json.dateType ''
	  end # Date
	  
	  #~ json.edition ''
	  #~ json.responsibleParty(dummy) do |party|
	    #~ json.contactId ''
	    #~ json.role ''
	  #~ end #responsibleParty
	  
	  #~ json.presentationForm ['']
	  #~ json.identifier(dummy) do |id|
		#~ json.identifier ''
	    #~ json.type 'abcd'
	    #~ json.authority do 
	      #~ json.title ''
	      #~ json.alteranteTitle ''
	      #~ json.date(dummy) do |date|
		    #~ json.date '0000-00-00'
	        #~ json.dateType ''
	      #~ end # Date
	      #~ json.responsibleParty(dummy) do |party|
			#~ json.contactId ''
			#~ json.role ''
	      #~ end #responsibleParty
	      #~ json.onlineResource(dummy) do |olr|
			#~ json.uri 'http://thisisanexample.com'
			#~ json.protocol ''
			#~ json.name ''
			#~ json.description ''
			#~ json.function ''
	      #~ end #onlineResource
	      
	    #~ end #authority
	    
	  #~ end #identifier
	  
	  #~ json.onlineResource(dummy) do |olr|
	    #~ json.uri 'http://thisisanexample.com'
	    #~ json.protocol ''
	    #~ json.name ''
	    #~ json.description ''
	    #~ json.function ''
	  #~ end #onlineResource
	 
	end #citation
	
	#~ json.resourceTimePeriod do
	  #~ json.description ''
	  #~ json.beginPosition '0000-00-00'
	  #~ json.endPosition '0000-00-00'
	#~ end #resourceTimePeriod
	
	json.pointOfContact(dummy) do |contact|
	  json.contactId '2'
	  json.role 'person'
	end #pointOfContact
	
	json.abstract ''
    #~ json.shortAbstract ''
    json.status ''
    #~ json.hasMapLocation true
    #~ json.hasDataAvailable true
    json.language ['']
    #~ json.characterSet ['']
    #~ json.locale(dummy) do |locale|
      #~ json.language ''
	  #~ json.country ''
	  #~ json.characterSet ''
	#~ end #locale
	#~ json.purpose ''
    #~ json.credit ['']
    #~ json.topicCategory ['']
    #~ json.environmentDescription ''
    #~ json.resourceNativeFormat
	
  end #resourceInfo
end

#json.title @entry.title


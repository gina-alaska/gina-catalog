# part of gLynx

# this class has the job to export metadata in the ISO 19115_2 foramt

class MetadataExportJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers
  #~ require 'adiwg/mdtranslator'
    
  # gets data from adiwg api enpoint and creates ISO 19115_2 metadata
  def perform(id)
    uri = URI(api_adiwg_url(id: id))
    response = Net::HTTP.get_response(uri)
    metadata = ADIWG::Mdtranslator.translate(
      file: response.body, 
      reader: 'mdJson', 
        #~ writer: 'iso19115_2',
        #~ validate: 'normal', 
        #~ showAllTags: false, 
        #~ cssLink: nil
    )
    crsh
    puts metadata
  end
  
  protected
  # sets up url space
  def default_url_options
    {host: Rails.application.secrets.adiwg_host}
  end
end

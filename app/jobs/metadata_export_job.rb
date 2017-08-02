# part of gLynx

# this class has the job to export metadata in the ISO 19115_2 foramt

class MetadataExportJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers
  #~ require 'adiwg/mdtranslator'
    
  # gets data from adiwg api enpoint and creates ISO 19115_2 metadata
  def perform(entry)
    uri = URI(api_adiwg_url(id: entry.id))
    response = Net::HTTP.get_response(uri)
    metadata = ADIWG::Mdtranslator.translate(
      file: response.body, 
      reader: 'mdJson', 
      writer: 'iso19115_2',
      #~ validate: 'normal', 
      #~ showAllTags: false, 
      #~ cssLink: nil
    )
    brk
    if metadata[:readerValidationPass]
      file = Tempfile.new( [entry.id.to_s + "_metadata", 'xml'] )
      file.write( metadata[:writerOutput] )
      attachment = entry.attachments.where( file_name: "glynx_#{entry.id}_iso19115-2_metadata.xml" ).first_or_initialize
      attachment.file = file
      attachment.file_name = "glynx_#{entry.id}_iso19115-2_metadata.xml"
      attachment.description = 'glynx iso19115-2 metadata'
      attachment.category = 'Metadata'
      attachment.save
    #~ else
      
    end
    
  end
  
  protected
  # sets up url space
  def default_url_options
    {host: Rails.application.secrets.adiwg_host}
  end
end

class MetadataExportJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers

    
  def perform(id)
    # Do something later
    uri = URI(api_adiwg_url(id: id))
    response = Net::HTTP.get_response(uri)
    json_data = response.body
    
  end
  
  protected
  def default_url_options
    {host: Rails.application.secrets.adiwg_host}
  end


end


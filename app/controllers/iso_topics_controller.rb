class IsoTopicsController < ApplicationController
  respond_to :json

  def index
    @iso_topics = IsoTopic.all    
    respond_with({ :iso_topics => @iso_topics })
  end
end

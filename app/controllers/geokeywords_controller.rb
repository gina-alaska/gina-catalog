class GeokeywordsController < ApplicationController
  respond_to :json

  def index
    @geokeywords = Geokeyword.all    
    respond_with({ :geokeywords => @geokeywords })
  end
  
end

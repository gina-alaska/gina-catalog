class HelpController < ApplicationController
  def index
  end

  def cms
    @subsection = params['id']

    respond_to do |format|
      format.html
      format.js
    end
  end
end

class SitemapsController < ApplicationController
  def index
    @pages = current_portal.pages.where(hidden: false, draft: false, parent_id: nil)

    respond_to do |format|
      format.html
      format.xml
    end
  end
end

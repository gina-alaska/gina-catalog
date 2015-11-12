class SitemapsController < ApplicationController
  def index
    @pages = current_portal.pages.where(hidden: false, draft: false, parent_id: nil)
    #@page = current_portal.pages.where(slug: 'sitemap').first
    #if params[:format] == "xml"
    #  excludes = ["404-not-found"]
    #else
    #  excludes = ["home", "404-not-found", "sitemap"]
    #end

    #@setup_pages = current_setup.pages.autolinkable.roots.where("slug NOT IN (?)", excludes)

    respond_to do |format|
      format.html  
      format.xml
    end
  end
end

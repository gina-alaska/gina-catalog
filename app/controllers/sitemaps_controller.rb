class SitemapsController < ApplicationController
  def show
    @page = current_setup.pages.where(slug: 'sitemap').first
    excludes = ["home", "404-not-found", "sitemap"]
    @setup_pages = current_setup.pages.roots.where("slug NOT IN (?)", excludes)

    respond_to do |format|
      format.html
    end
  end 
end

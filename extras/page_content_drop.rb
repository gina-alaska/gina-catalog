class PageContentDrop < Liquid::Drop
  def initialize(page)
    @page = page
  end
  
  def before_method(section)
    @page.content_for(section)
  end

  def top_pages
  	@page.setup.pages.roots.autolinkable
  end
end
class PageContentDrop < Liquid::Drop
  def initialize(page)
    @page = page
  end
  
  def before_method(section)
    @page.content_for(section)
  end
end
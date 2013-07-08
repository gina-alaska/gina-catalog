class PageSnippetDrop < Liquid::Drop
  def initialize(setup, page = nil)
    @setup = setup
    @page = page
  end
  
  def before_method(snippet)
    CmsRenderers.snippet(@setup.snippets.where(slug: snippet).first, @setup, @page)
  end
end
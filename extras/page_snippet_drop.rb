class PageSnippetDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end
  
  def before_method(snippet)
    CmsRenderers.snippet(@setup.snippets.where(slug: snippet).first, @setup)
  end
end
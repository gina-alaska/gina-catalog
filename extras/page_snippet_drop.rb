class PageSnippetDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end
  
  def before_method(snippet)
    @setup.snippets.where(slug: snippet).first.try(:content)
  end
end
class SetupSubpageDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def top_pages
    @setup.pages.roots.autolinkable
  end
  
  def before_method(page)
    @setup.pages.where(slug: page).first
  end
end
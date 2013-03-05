class SetupSubpageDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end
  
  def before_method(page)
    @setup.pages.where(slug: page).first
  end
end
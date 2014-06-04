class SetupPortalsDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def children
    @setup.descendants
  end

  def parent
    @setup.parent
  end

  def siblings
    @setup.siblings
  end
end
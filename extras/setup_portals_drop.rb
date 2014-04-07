class SetupPortalsDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def list
    @setup.descendants
  end
end
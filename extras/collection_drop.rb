class CollectionDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def before_method(id)
    @setup.collections.visible_to.find(id) 
  end

  def all
  	@setup.collections.visible_to
  end
end

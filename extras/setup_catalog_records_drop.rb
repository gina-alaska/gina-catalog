class SetupCatalogRecordsDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def latest
    @setup.catalogs.order('updated_at DESC').limit(10).all
  end
end
class SetupCatalogRecordsDrop < Liquid::Drop
  def initialize(setup)
    @setup = setup
  end

  def latest
    @setup.catalogs.where("published_at <= ?", Time.now.utc).order('updated_at DESC').limit(10).all
  end
end
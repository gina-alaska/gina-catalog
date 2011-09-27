class SetupGeokeywords < ActiveRecord::Migration
  def self.up
    akregion = Region.find_by_name('alaska')
    alaska = Geokeyword.create(:name => 'Alaska', :geom => akregion.geom.envelope.center)
    Location.intersects(akregion.geom).each do |l|
      asset = l.asset
      asset.geokeywords << alaska unless asset.geokeywords.exists? alaska
      asset.save!
    end

    nsbregion = Region.find_by_name('nsb')
    northslope = Geokeyword.create(:name => 'Northslope Borough', :geom => nsbregion.geom.envelope.center)
    Location.intersects(nsbregion.geom).each do |l|
      asset = l.asset
      asset.geokeywords << northslope unless asset.geokeywords.exists? northslope
      asset.save!
    end
  end

  def self.down
  end
end

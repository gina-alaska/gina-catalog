class SetupGeokeywords < ActiveRecord::Migration
  def self.up
    akregion = Region.find_by_name('alaska')
    alaska = Geokeyword.new(:name => 'Alaska')
    alaska.geom = akregion.geom.envelope.center
    alaska.save!

    Location.intersects(akregion.geom).each do |l|
      asset = l.asset
      asset.geokeywords << alaska unless asset.geokeywords.exists? alaska
      asset.save!
    end

    nsbregion = Region.find_by_name('nsb')
    northslope = Geokeyword.new(:name => 'Northslope Borough')
    northslope.geom = nsbregion.geom.envelope.center
    northslope.save!

    Location.intersects(nsbregion.geom).each do |l|
      asset = l.asset
      asset.geokeywords << northslope unless asset.geokeywords.exists? northslope
      asset.save!
    end
  end

  def self.down
  end
end

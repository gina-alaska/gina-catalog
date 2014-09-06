class ChangeOwenerSiteIdToOwnerSiteId < ActiveRecord::Migration
  def change
  	change_table :entries do |t|
  		t.rename :owener_site_id, :owner_site_id
  	end
  end
end

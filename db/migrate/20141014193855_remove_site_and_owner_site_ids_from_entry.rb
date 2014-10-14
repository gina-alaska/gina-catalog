class RemoveSiteAndOwnerSiteIdsFromEntry < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.remove :site_id, :owner_site_id
    end
  end
end

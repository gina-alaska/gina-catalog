class ChangePortalToSetup < ActiveRecord::Migration
  def up
    change_table :contact_infos do |t|
      t.rename :portal_id, :setup_id
    end
  end

  def down
    change_table :contact_infos do |t|
      t.rename :setup_id, :portal_id
    end
  end
end

class AddSiteIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :site_id, :integer
  end
end

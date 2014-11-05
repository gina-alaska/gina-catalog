class AddPortalIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :portal_id, :integer
  end
end

class ChangeAgencyIdToOrganizationId < ActiveRecord::Migration
  def change
    rename_column :entry_organizations, :agency_id, :organization_id
  end
end

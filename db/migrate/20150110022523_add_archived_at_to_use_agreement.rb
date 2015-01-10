class AddArchivedAtToUseAgreement < ActiveRecord::Migration
  def change
    add_column :use_agreements, :archived_at, :datetime
  end
end

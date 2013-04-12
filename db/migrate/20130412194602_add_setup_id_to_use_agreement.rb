class AddSetupIdToUseAgreement < ActiveRecord::Migration
  def change
    add_column :use_agreements, :setup_id, :integer
  end
end

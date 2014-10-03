class AddUseAgreementIdToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :use_agreement_id, :integer
  end
end

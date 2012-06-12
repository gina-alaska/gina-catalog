class AddUseAgreementToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalog, :use_agreement_id, :integer
  end
end

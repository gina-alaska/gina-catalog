class AddSdsAttributesToCswImports < ActiveRecord::Migration
  def change
    add_column :csw_imports, :use_agreement_id, :integer
    add_column :csw_imports, :request_contact_info, :boolean, default: false
    add_column :csw_imports, :require_contact_info, :boolean, default: false
  end
end

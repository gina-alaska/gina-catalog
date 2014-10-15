class AddSdsFieldsToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :request_contact_info, :boolean
    add_column :entries, :require_contact_info, :boolean
  end
end

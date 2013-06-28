class AddMoreFieldsToContactInfoTable < ActiveRecord::Migration
  def change
    add_column :contact_infos, :user_ip, :string
    add_column :contact_infos, :portal_id, :integer
    add_column :contact_infos, :user_id, :integer
    add_column :contact_infos, :user_agent, :text
  end
end

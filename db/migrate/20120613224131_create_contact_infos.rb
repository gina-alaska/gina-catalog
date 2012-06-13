class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.integer     :catalog_id
      t.string      :name
      t.string      :email
      t.string      :phone_number
      t.string      :usage_description
      t.timestamps
    end
  end
end

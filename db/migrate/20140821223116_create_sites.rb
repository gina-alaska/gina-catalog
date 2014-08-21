class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :title
      t.string :by_line
      t.string :acronym
      t.text :description
      t.string :url
      t.string :logo_uid
      t.string :contact_email
      t.string :analytics_account

      t.timestamps
    end
  end
end

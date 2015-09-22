class CreateCmsAttachments < ActiveRecord::Migration
  def change
    create_table :cms_attachments do |t|
      t.string :name
      t.text :description
      t.string :file_id
      t.string :file_filename
      t.integer :file_size
      t.string :file_content_type
      t.references :portal, index: true

      t.timestamps null: false
    end
    add_foreign_key :cms_attachments, :portals
  end
end

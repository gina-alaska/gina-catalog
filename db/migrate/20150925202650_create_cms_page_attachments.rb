class CreateCmsPageAttachments < ActiveRecord::Migration
  def change
    create_table :cms_page_attachments do |t|
      t.references :page, index: true
      t.references :attachment, index: true
      t.integer :position

      t.timestamps null: false
    end
    # add_foreign_key :cms_page_attachments, :cms_pages
    # add_foreign_key :cms_page_attachments, :cms_attachments
  end
end

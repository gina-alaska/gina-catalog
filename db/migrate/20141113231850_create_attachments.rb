class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :entry_id
      t.string :file_uid
      t.integer :file_size
      t.string :file_name
      t.string :interaction
      t.string :uuid
      t.string :description

      t.timestamps
    end
  end
end

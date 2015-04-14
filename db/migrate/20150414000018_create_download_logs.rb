class CreateDownloadLogs < ActiveRecord::Migration
  def change
    create_table :download_logs do |t|
      t.string :file_name
      t.text :user_agent
      t.references :user, index: true
      t.references :attachment, index: true

      t.timestamps null: false
    end
    add_foreign_key :download_logs, :users
    add_foreign_key :download_logs, :attachments
  end
end

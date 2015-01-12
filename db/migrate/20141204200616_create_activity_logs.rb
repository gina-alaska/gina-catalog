class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string :activity
      t.string :loggable_type
      t.integer :loggable_id
      t.integer :user_id
      t.text :message
      t.integer :entry_id
      t.integer :portal_id

      t.timestamps
    end
  end
end

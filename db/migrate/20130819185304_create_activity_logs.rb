class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string     :activity
      t.integer    :user_id
      t.datetime   :performed_at
      t.text       :log
      t.references :loggable, polymorphic: true
      
      t.timestamps
    end
  end
end

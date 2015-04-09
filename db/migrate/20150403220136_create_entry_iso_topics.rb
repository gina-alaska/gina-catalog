class CreateEntryIsoTopics < ActiveRecord::Migration
  def change
    create_table :entry_iso_topics do |t|
      t.integer :entry_id
      t.integer :iso_topic_id

      t.timestamps null: false
    end
  end
end

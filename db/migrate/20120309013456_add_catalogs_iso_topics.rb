class AddCatalogsIsoTopics < ActiveRecord::Migration
  def change
    create_table :catalogs_iso_topics, :id => false do |t|
      t.integer   :catalog_id
      t.integer   :iso_topic_id
      t.timestamps
    end
  end
end

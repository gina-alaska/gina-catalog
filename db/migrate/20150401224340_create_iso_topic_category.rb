class CreateIsoTopicCategory < ActiveRecord::Migration
  def change
    create_table :iso_topic_categories do |t|
      t.string :name, limit: 50
      t.string :long_name, limit: 200
      t.string :iso_theme_code, limit: 3

      t.timestamps
    end
  end
end

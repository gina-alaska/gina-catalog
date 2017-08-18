class CreateEntryExports < ActiveRecord::Migration
  def change
    create_table :entry_exports do |t|
      t.text :serialized_search
      t.boolean :organizations
      t.boolean :collections
      t.boolean :contacts
      t.boolean :data
      t.boolean :description
      t.boolean :info
      t.boolean :iso
      t.boolean :links
      t.boolean :location
      t.boolean :tags
      t.boolean :title
      t.boolean :url
      t.integer :limit
      t.integer :description_chars
      t.text :format_type

      t.timestamps null: false
    end
  end
end

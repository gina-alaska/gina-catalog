class AddDefaultToEntryCollectionsCountInCollection < ActiveRecord::Migration
  def change
    change_column_default :collections, :entry_collections_count, 0
  end
end

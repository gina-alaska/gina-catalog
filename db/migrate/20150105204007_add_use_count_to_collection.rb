class AddUseCountToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :entry_collections_count, :integer

    reversible do |dir|
      dir.up do
        Collection.all.each do |coll|
          Collection.reset_counters(coll.id, :entry_collections)
        end
      end
    end
  end
end

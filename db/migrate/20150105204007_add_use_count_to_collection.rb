class AddUseCountToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :use_count, :integer
  end
end

class ChangePublishedAtToDateTime < ActiveRecord::Migration
  def change
    remove_column :entries, :published_at
    add_column :entries, :published_at, :datetime
  end
end

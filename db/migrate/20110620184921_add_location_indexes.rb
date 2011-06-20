class AddLocationIndexes < ActiveRecord::Migration
  def self.up
    add_index :locations, [:locatable_id, :locatable_type], :name => :as_locatable
    add_index :projects, :published_at
    add_index :projects, [:id, :published_at], :name => :project_published_id_index
  end

  def self.down
    remove_index :locations, :name => :as_locatable
    remove_index :projects, :published_at
    remove_index :projects, :name => :project_published_id_index
  end
end

class ChangePageSlugIndex < ActiveRecord::Migration
  def up
    change_table :cms_pages do |t|
      t.remove_index 'slug'
    end
    add_index :cms_pages, 'slug'
  end

  def down
    change_table :cms_pages do |t|
      t.remove_index 'slug'
    end
    add_index :cms_pages, 'slug', unique: true
  end
end

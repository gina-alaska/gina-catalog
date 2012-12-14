class AddLayoutIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :page_layout_id, :integer
  end
end

class AddUpdatedByToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :updated_by_id, :integer
  end
end

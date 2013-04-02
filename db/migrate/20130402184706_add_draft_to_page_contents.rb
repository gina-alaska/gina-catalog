class AddDraftToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :draft, :boolean, default: false
  end
end

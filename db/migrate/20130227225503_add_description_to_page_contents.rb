class AddDescriptionToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :description, :string
  end
end

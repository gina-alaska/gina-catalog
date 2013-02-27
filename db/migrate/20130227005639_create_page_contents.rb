class CreatePageContents < ActiveRecord::Migration
  def change
    rename_table :pages, :page_contents
  end
end

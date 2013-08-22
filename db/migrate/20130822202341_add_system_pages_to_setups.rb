class AddSystemPagesToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :system_page, :boolean
  end
end

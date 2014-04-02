class AddValidAndCheckDateToLinks < ActiveRecord::Migration
  def change
    add_column :links, :valid_link, :boolean, default: true
    add_column :links, :last_checked_at, :date
  end
end

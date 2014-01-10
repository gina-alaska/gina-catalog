class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :message_type, :string
  end
end

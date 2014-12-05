class RenameInteractionToCategory < ActiveRecord::Migration
  def change
    rename_column :attachments, :interaction, :category
  end
end

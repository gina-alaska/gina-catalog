class ChangeImageDescriptionFieldToText < ActiveRecord::Migration
  def up
    change_column :images, :description, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
    change_column :images, :description, :string
  end
end

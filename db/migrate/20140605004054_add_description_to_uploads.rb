class AddDescriptionToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :description, :string
  end
end

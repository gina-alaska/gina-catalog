class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string      :repohex, :null => false
      t.string      :slug, :null => false
      t.integer     :catalog_id, :null => false
      t.timestamps
    end
  end
end

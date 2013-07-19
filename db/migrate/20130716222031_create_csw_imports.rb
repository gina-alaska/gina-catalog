class CreateCswImports < ActiveRecord::Migration
  def change
    create_table :csw_imports do |t|
      t.string  :url
      t.integer :sync_frequency, default: 24   #hours 
      t.integer :setup_id
      t.string  :title
      t.timestamps
    end

    add_column :catalog, :csw_import_id, :integer
  end
end

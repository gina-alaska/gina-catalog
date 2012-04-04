class CreateDataTypes < ActiveRecord::Migration
  def change
    create_table :data_types do |t|
      t.string      :name, :null => false
      t.string      :description

      t.timestamps
    end
    
    create_table :catalogs_data_types, :id => false do |t|
      t.integer     :catalog_id
      t.integer     :data_type_id
    end
  end
end

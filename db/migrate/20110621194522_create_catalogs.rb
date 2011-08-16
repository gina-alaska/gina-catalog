class CreateCatalogs < ActiveRecord::Migration
  def self.up
    create_table :catalog do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :type
      t.string :source_url
      t.string :uuid

      t.integer :owner_id
      t.integer :primary_contact_id

      t.integer :license_id
      t.integer :data_source_id
      t.integer :source_agency_id
      t.integer :funding_agency_id

      t.datetime :archived_at
      t.datetime :published_at
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    create_table :catalog_agencies, :id => false do |t|
      t.integer :agency_id
      t.integer :catalog_id
    end
    create_table :catalog_people, :id => false do |t|
      t.integer :person_id
      t.integer :catalog_id
    end
    create_table :catalog_tags, :id => false do |t|
      t.integer :tag_id
      t.integer :catalog_id
    end

    rename_table :assets, :old_assets
    rename_table :projects, :old_projects

    rename_table :locations, :old_locations

    create_table :locations do |t|
      t.string :name
      t.string :region
      t.string :subregion

      t.integer :asset_id
      t.string  :asset_type

      t.geometry :geom, :srid => 4326
      t.timestamps
    end

    rename_table :links, :old_links

    create_table :links do |t|
      t.string :category
      t.string :display_text
      t.string :url

      t.integer :asset_id
      t.string  :asset_type

      t.timestamps
    end
  end

  def self.down
    rename_table :old_projects, :projects
    rename_table :old_assets, :assets
    drop_table :catalog
    drop_table :catalog_agencies
    drop_table :catalog_people
    drop_table :catalog_tags

    drop_table :locations
    rename_table :old_locations, :locations

    drop_table :links
    rename_table :old_links, :links
  end
end

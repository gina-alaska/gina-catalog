# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110926191312) do

  create_table "abstracts", :force => true do |t|
    t.column "project_id", :string
    t.column "text", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "addresses", :force => true do |t|
    t.column "line1", :string
    t.column "line2", :string
    t.column "country", :string
    t.column "state", :string
    t.column "city", :string
    t.column "zipcode", :string
    t.column "person_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "agencies", :force => true do |t|
    t.column "name", :string, :limit => 80
    t.column "category", :string
    t.column "description", :string
    t.column "acronym", :string, :limit => 15
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "active", :boolean, :default => true
    t.column "adiwg_code", :string
    t.column "adiwg_path", :string
  end

  create_table "agency_people", :force => true do |t|
    t.column "person_id", :integer
    t.column "agency_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "asset_descriptions", :force => true do |t|
    t.column "asset_id", :integer
    t.column "text", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "asset_files", :force => true do |t|
    t.column "asset_revision_id", :integer
    t.column "filename", :string
    t.column "size", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "mime_type_id", :integer
    t.column "asset_id", :integer
  end

  create_table "asset_revisions", :force => true do |t|
    t.column "asset_id", :integer
    t.column "name", :string
    t.column "description", :string
    t.column "archived_at", :datetime
    t.column "finalized_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "assets_gcmd_themes", :id => false, :force => true do |t|
    t.column "gcmd_theme_id", :integer
    t.column "asset_id", :integer
  end

  create_table "assets_tags", :id => false, :force => true do |t|
    t.column "asset_id", :integer
    t.column "tag_id", :integer
  end

  create_table "catalog", :force => true do |t|
    t.column "title", :string
    t.column "description", :text
    t.column "status", :string
    t.column "type", :string
    t.column "source_url", :string
    t.column "uuid", :string
    t.column "owner_id", :integer
    t.column "primary_contact_id", :integer
    t.column "license_id", :integer
    t.column "data_source_id", :integer
    t.column "source_agency_id", :integer
    t.column "funding_agency_id", :integer
    t.column "archived_at", :datetime
    t.column "published_at", :datetime
    t.column "start_date", :datetime
    t.column "end_date", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "repohex", :string
  end

  create_table "catalog_agencies", :id => false, :force => true do |t|
    t.column "agency_id", :integer
    t.column "catalog_id", :integer
  end

  create_table "catalog_people", :id => false, :force => true do |t|
    t.column "person_id", :integer
    t.column "catalog_id", :integer
  end

  create_table "catalog_tags", :id => false, :force => true do |t|
    t.column "tag_id", :integer
    t.column "catalog_id", :integer
  end

  create_table "catalogs_geokeywords", :id => false, :force => true do |t|
    t.column "catalog_id", :integer
    t.column "geokeyword_id", :integer
  end

  create_table "content_types", :force => true do |t|
    t.column "name", :string, :limit => 40
    t.column "long_name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "data_sources", :force => true do |t|
    t.column "name", :string
    t.column "url_template", :string
    t.column "logo", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "delayed_jobs", :force => true do |t|
    t.column "priority", :integer, :default => 0
    t.column "attempts", :integer, :default => 0
    t.column "handler", :text
    t.column "last_error", :text
    t.column "run_at", :datetime
    t.column "locked_at", :datetime
    t.column "failed_at", :datetime
    t.column "locked_by", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "features", :force => true do |t|
    t.column "class", :string, :limit => 1
    t.column "code", :string, :limit => 20
    t.column "name", :string
    t.column "description", :string
  end

  create_table "features_new", :force => true do |t|
    t.column "class", :string, :limit => 1
    t.column "code", :string, :limit => 20
    t.column "name", :string
    t.column "description", :string
  end

  create_table "gcmd_science_keywords", :force => true do |t|
    t.column "topic", :string, :limit => 50
    t.column "term", :string, :limit => 200
    t.column "variable_level_1", :string
    t.column "variable_level_2", :string
    t.column "variable_level_3", :string
    t.column "label", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "gcmd_themes", :force => true do |t|
    t.column "name", :string, :limit => 60
    t.column "parent_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "descendant_granules_count", :integer
    t.column "path", :string
  end

  create_table "gcmd_themes_granules", :id => false, :force => true do |t|
    t.column "gcmd_theme_id", :integer
    t.column "granule_id", :integer
  end

  create_table "gcmd_themes_projects", :id => false, :force => true do |t|
    t.column "gcmd_theme_id", :integer
    t.column "project_id", :integer
  end

  create_table "geokeywords", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :point, :srid => 4326
  end

  create_table "geolocations", :force => true do |t|
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "point", :geometry, :srid => nil
    t.column "llgeom", :geometry, :srid => nil
  end

  create_table "granule_files", :force => true do |t|
    t.column "granule_id", :integer
    t.column "filename", :string
    t.column "processed", :boolean, :default => false
    t.column "metadata", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "granules", :force => true do |t|
    t.column "name", :string, :limit => 40
    t.column "iso_guid", :string
    t.column "gcmd_theme_id", :integer
    t.column "path", :string
    t.column "begin_date", :datetime
    t.column "end_date", :datetime
    t.column "content_type_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "llgeom", :geometry, :srid => nil
    t.column "dataset_title", :string, :limit => 100
    t.column "abstract", :string
    t.column "purpose", :string
    t.column "supplemental_information", :string
    t.column "originator", :string, :limit => 100
    t.column "publisher", :string, :limit => 100
    t.column "credit", :string, :limit => 100
    t.column "iso_theme_id", :integer
    t.column "language", :string, :limit => 25
    t.column "character_set", :string, :limit => 25
    t.column "llgeom_raw", :geometry, :srid => nil
    t.column "progress", :string, :default => "INPROCESS"
  end

  create_table "iso_topic_categories", :force => true do |t|
    t.column "name", :string, :limit => 50
    t.column "long_name", :string, :limit => 200
    t.column "iso_theme_code", :string, :limit => 3
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "licenses", :force => true do |t|
    t.column "name", :string
    t.column "synonym", :string
    t.column "description", :string
    t.column "rights_holder_name", :string
    t.column "downloadable", :boolean
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "links", :force => true do |t|
    t.column "category", :string
    t.column "display_text", :string
    t.column "url", :string
    t.column "asset_id", :integer
    t.column "asset_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "locations", :force => true do |t|
    t.column "name", :string
    t.column "region", :string
    t.column "subregion", :string
    t.column "asset_id", :integer
    t.column "asset_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => 4326
  end

  create_table "metadata_messages", :force => true do |t|
    t.column "granule_file_id", :integer
    t.column "text", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "mime_type_extensions", :force => true do |t|
    t.column "extension", :string
    t.column "icon", :string
    t.column "mime_type_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "mime_types", :force => true do |t|
    t.column "content_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "notes", :force => true do |t|
    t.column "noted_id", :integer
    t.column "noted_type", :string
    t.column "text", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "old_assets", :force => true do |t|
    t.column "title", :string
    t.column "description", :string
    t.column "data_source_id", :integer
    t.column "mime_type_id", :integer
    t.column "start_date", :datetime
    t.column "end_date", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => nil
    t.column "owner_id", :integer
    t.column "source_agency_id", :integer
    t.column "delta", :boolean, :default => true, :null => false
    t.column "primary_contact_id", :integer
    t.column "published_at", :datetime
    t.column "license_id", :integer
    t.column "path", :string
    t.column "archived_at", :datetime
    t.column "status", :string
    t.column "funding_agency_id", :integer
  end

  create_table "old_links", :force => true do |t|
    t.column "display_text", :string
    t.column "category", :string, :null => false
    t.column "url", :string, :null => false
    t.column "linkable_id", :integer
    t.column "linkable_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "old_locations", :force => true do |t|
    t.column "name", :string
    t.column "feature_id", :integer
    t.column "region", :string
    t.column "subregion", :string
    t.column "locatable_id", :integer
    t.column "locatable_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => nil
  end

  add_index "old_locations", ["locatable_id", "locatable_type"], :name => "as_locatable"
  add_index "old_locations", ["geom"], :name => "index_locations_on_geom", :spatial=> true 

  create_table "old_notes", :force => true do |t|
    t.column "project_id", :integer
    t.column "text", :text
    t.column "user_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "old_projects", :force => true do |t|
    t.column "title", :string
    t.column "agency_id", :integer
    t.column "parent_id", :integer
    t.column "status_id", :integer
    t.column "phase_id", :integer
    t.column "location_id", :integer
    t.column "report_id", :integer
    t.column "user_id", :integer
    t.column "budget", :decimal, :precision => 12, :scale => 2
    t.column "start_date", :datetime
    t.column "end_date", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "source_url", :string
    t.column "year_funded", :string, :limit => 4
    t.column "remote_source_id", :string
    t.column "data_source_id", :integer
    t.column "published_at", :datetime
    t.column "published_by", :integer
    t.column "owner_id", :integer
    t.column "status", :string
    t.column "primary_contact_id", :integer
    t.column "delta", :boolean, :default => true, :null => false
    t.column "source_agency_id", :integer
    t.column "description", :text
    t.column "archived_at", :datetime
    t.column "funding_agency_id", :integer
    t.column "uuid", :string
  end

  add_index "old_projects", ["published_at"], :name => "index_projects_on_published_at"
  add_index "old_projects", ["id", "published_at"], :name => "project_published_id_index"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.column "issued", :integer
    t.column "lifetime", :integer
    t.column "handle", :string
    t.column "assoc_type", :string
    t.column "server_url", :binary
    t.column "secret", :binary
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.column "timestamp", :integer, :null => false
    t.column "server_url", :string
    t.column "salt", :string, :null => false
  end

  create_table "people", :force => true do |t|
    t.column "salutation", :string
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "suffix", :string
    t.column "email", :string
    t.column "url", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "permissions", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "phone_numbers", :force => true do |t|
    t.column "person_id", :integer
    t.column "digits", :string
    t.column "name", :string, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "project_agencies", :force => true do |t|
    t.column "project_id", :integer
    t.column "agency_id", :integer
    t.column "funding", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "project_contacts", :force => true do |t|
    t.column "project_id", :integer
    t.column "person_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "project_geolocations", :force => true do |t|
    t.column "project_id", :integer
    t.column "geolocation_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "project_locations", :force => true do |t|
    t.column "project_id", :integer
    t.column "location_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "project_themes", :force => true do |t|
    t.column "project_id", :integer
    t.column "theme_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "projects_tags", :id => false, :force => true do |t|
    t.column "project_id", :integer
    t.column "tag_id", :integer
  end

  create_table "role_permissions", :force => true do |t|
    t.column "role_id", :integer
    t.column "permission_id", :integer
  end

  create_table "roles", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.column "version", :integer
  end

  create_table "settings", :force => true do |t|
    t.column "name", :string
    t.column "value", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "spreadsheet_projects", :id => false, :force => true do |t|
    t.column "recno", :integer
    t.column "Yr 1st Funded", :string, :limit => 75
    t.column "Funding Source", :string, :limit => 250
    t.column "funding source acronym", :string, :limit => 75
    t.column "Point of Contact", :string, :limit => 75
    t.column "PC Affiliation", :string, :limit => 75
    t.column "PC Phone", :string, :limit => 75
    t.column "PC Email", :string, :limit => 75
    t.column "Other Cooperators", :string, :limit => 250
    t.column "other cooperators acronym", :string, :limit => 250
    t.column "Theme", :string, :limit => 250
    t.column "Other Theme", :string, :limit => 250
    t.column "Location", :string, :limit => 250
    t.column "Other Location", :string, :limit => 250
    t.column "Keyword", :string, :limit => 300
    t.column "Original Start Date", :string, :limit => 75
    t.column "start date as date", :string, :limit => 75
    t.column "End Date/ On-Going", :string, :limit => 75
    t.column "Title", :string, :limit => 250
    t.column "Synopsis", :string, :limit => nil
    t.column "Report Status", :string, :limit => 200
    t.column "Report Location: Website/Contact", :string, :limit => 300
  end

  create_table "spreadsheet_projects_bup", :id => false, :force => true do |t|
    t.column "recno", :integer
    t.column "Yr 1st Funded", :string, :limit => 75
    t.column "Funding Source", :string, :limit => 250
    t.column "funding source acronym", :string, :limit => 75
    t.column "Point of Contact", :string, :limit => 75
    t.column "PC Affiliation", :string, :limit => 75
    t.column "PC Phone", :string, :limit => 75
    t.column "PC Email", :string, :limit => 75
    t.column "Other Cooperators", :string, :limit => 250
    t.column "other cooperators acronym", :string, :limit => 250
    t.column "Theme", :string, :limit => 250
    t.column "Other Theme", :string, :limit => 250
    t.column "Location", :string, :limit => 250
    t.column "Other Location", :string, :limit => 250
    t.column "Keyword", :string, :limit => 300
    t.column "Original Start Date", :string, :limit => 75
    t.column "start date as date", :string, :limit => 75
    t.column "End Date/ On-Going", :string, :limit => 75
    t.column "Title", :string, :limit => 250
    t.column "Synopsis", :string, :limit => nil
    t.column "Report Status", :string, :limit => 200
    t.column "Report Location: Website/Contact", :string, :limit => 300
  end

  create_table "synopses", :force => true do |t|
    t.column "project_id", :integer
    t.column "active", :boolean
    t.column "text", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "tags", :force => true do |t|
    t.column "text", :string
    t.column "highlight", :boolean, :default => false
  end

  create_table "tasks", :force => true do |t|
    t.column "target_id", :integer
    t.column "target_class", :string
    t.column "command", :string
    t.column "arguments", :text
    t.column "performed", :boolean, :default => false
    t.column "performed_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "tasks", ["performed"], :name => "tasks_index_tasks_on_performed"

  create_table "themes", :force => true do |t|
    t.column "name", :string, :limit => 80
    t.column "description", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "user_roles", :force => true do |t|
    t.column "user_id", :integer
    t.column "role_id", :integer
  end

  create_table "users", :force => true do |t|
    t.column "email", :string
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "remember_token", :string
    t.column "remember_token_expires_at", :datetime
    t.column "identity_url", :string
    t.column "agency_id", :integer
  end

  create_table "videos", :force => true do |t|
    t.column "name", :string
    t.column "title", :string
    t.column "filename", :string
    t.column "vidtype", :string, :default => "Camtasia Flash"
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "path", :string
  end

  create_table "zones", :force => true do |t|
    t.column "name", :string
    t.column "status", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :geometry, :srid => nil
    t.column "message", :string
    t.column "sort", :integer
  end

  add_index "zones", ["geom"], :name => "index_zones_on_geom", :spatial=> true 

end

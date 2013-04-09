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

ActiveRecord::Schema.define(:version => 20130408235540) do

  create_table "abstracts", :force => true do |t|
    t.string   "project_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies", :force => true do |t|
    t.string   "name",        :limit => 80
    t.string   "category"
    t.string   "description"
    t.string   "acronym",     :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                    :default => true
    t.string   "adiwg_code"
    t.string   "adiwg_path"
  end

  create_table "agencies_setups", :id => false, :force => true do |t|
    t.integer "agency_id"
    t.integer "setup_id"
  end

  add_index "agencies_setups", ["agency_id", "setup_id"], :name => "index_agencies_setups_on_agency_id_and_setup_id"
  add_index "agencies_setups", ["agency_id"], :name => "index_agencies_setups_on_agency_id"
  add_index "agencies_setups", ["setup_id"], :name => "index_agencies_setups_on_setup_id"

  create_table "agency_people", :force => true do |t|
    t.integer  "person_id"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asset_descriptions", :force => true do |t|
    t.integer  "asset_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asset_files", :force => true do |t|
    t.integer  "asset_revision_id"
    t.string   "filename"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mime_type_id"
    t.integer  "asset_id"
  end

  create_table "asset_revisions", :force => true do |t|
    t.integer  "asset_id"
    t.string   "name"
    t.string   "description"
    t.datetime "archived_at"
    t.datetime "finalized_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets_gcmd_themes", :id => false, :force => true do |t|
    t.integer "gcmd_theme_id"
    t.integer "asset_id"
  end

  create_table "assets_tags", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "tag_id"
  end

  create_table "carousel_images_setups", :id => false, :force => true do |t|
    t.integer "setup_id"
    t.integer "image_id"
  end

  create_table "catalog", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.string   "type"
    t.string   "source_url"
    t.string   "uuid"
    t.integer  "owner_id"
    t.integer  "primary_contact_id"
    t.integer  "license_id"
    t.integer  "data_source_id"
    t.integer  "source_agency_id"
    t.integer  "funding_agency_id"
    t.datetime "archived_at"
    t.datetime "published_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repohex"
    t.boolean  "long_term_monitoring"
    t.integer  "use_agreement_id"
    t.boolean  "request_contact_info", :default => false
    t.boolean  "require_contact_info", :default => false
  end

  create_table "catalog_agencies", :id => false, :force => true do |t|
    t.integer "agency_id"
    t.integer "catalog_id"
  end

  create_table "catalog_collections", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "setup_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "catalog_collections_catalogs", :id => false, :force => true do |t|
    t.integer "catalog_id"
    t.integer "catalog_collection_id"
  end

  create_table "catalog_people", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "catalog_id"
  end

  create_table "catalog_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "catalog_id"
  end

  create_table "catalogs_data_types", :id => false, :force => true do |t|
    t.integer "catalog_id"
    t.integer "data_type_id"
  end

  create_table "catalogs_geokeywords", :id => false, :force => true do |t|
    t.integer "catalog_id"
    t.integer "geokeyword_id"
  end

  create_table "catalogs_iso_topics", :id => false, :force => true do |t|
    t.integer  "catalog_id"
    t.integer  "iso_topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "catalogs_setups", :id => false, :force => true do |t|
    t.integer "catalog_id"
    t.integer "setup_id"
  end

  add_index "catalogs_setups", ["setup_id"], :name => "index_catalogs_setups_on_setup_id"

  create_table "contact_infos", :force => true do |t|
    t.integer  "catalog_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "usage_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "setup_id"
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "content_types", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "long_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_sources", :force => true do |t|
    t.string   "name"
    t.string   "url_template"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "download_urls", :force => true do |t|
    t.string   "name"
    t.string   "file_type"
    t.string   "url"
    t.integer  "catalog_id"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string "class",       :limit => 1
    t.string "code",        :limit => 20
    t.string "name"
    t.string "description"
  end

  create_table "features_new", :force => true do |t|
    t.string "class",       :limit => 1
    t.string "code",        :limit => 20
    t.string "name"
    t.string "description"
  end

  create_table "gcmd_science_keywords", :force => true do |t|
    t.string   "topic",            :limit => 50
    t.string   "term",             :limit => 200
    t.string   "variable_level_1"
    t.string   "variable_level_2"
    t.string   "variable_level_3"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gcmd_themes", :force => true do |t|
    t.string   "name",                      :limit => 60
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "descendant_granules_count"
    t.string   "path"
  end

  create_table "gcmd_themes_granules", :id => false, :force => true do |t|
    t.integer "gcmd_theme_id"
    t.integer "granule_id"
  end

  create_table "gcmd_themes_projects", :id => false, :force => true do |t|
    t.integer "gcmd_theme_id"
    t.integer "project_id"
  end

  create_table "geokeywords", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",       :limit => {:srid=>4326, :type=>"point"}
  end

  create_table "geolocations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "point",      :limit => {:srid=>4326, :type=>"point"}
    t.spatial  "llgeom",     :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  create_table "granule_files", :force => true do |t|
    t.integer  "granule_id"
    t.string   "filename"
    t.boolean  "processed",  :default => false
    t.boolean  "metadata",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "granules", :force => true do |t|
    t.string   "name",                     :limit => 40
    t.string   "iso_guid"
    t.integer  "gcmd_theme_id"
    t.string   "path"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.integer  "content_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "llgeom",                   :limit => {:srid=>4326, :type=>"multi_polygon"}
    t.string   "dataset_title",            :limit => 100
    t.string   "abstract"
    t.string   "purpose"
    t.string   "supplemental_information"
    t.string   "originator",               :limit => 100
    t.string   "publisher",                :limit => 100
    t.string   "credit",                   :limit => 100
    t.integer  "iso_theme_id"
    t.string   "language",                 :limit => 25
    t.string   "character_set",            :limit => 25
    t.spatial  "llgeom_raw",               :limit => {:srid=>4326, :type=>"multi_polygon"}
    t.string   "progress",                                                                  :default => "INPROCESS"
  end

  create_table "images", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "link_to_url"
    t.string   "file_uid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "file_name"
  end

  create_table "images_setups", :id => false, :force => true do |t|
    t.integer "setup_id"
    t.integer "image_id"
  end

  create_table "iso_topic_categories", :force => true do |t|
    t.string   "name",           :limit => 50
    t.string   "long_name",      :limit => 200
    t.string   "iso_theme_code", :limit => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", :force => true do |t|
    t.string   "name"
    t.string   "synonym"
    t.string   "description"
    t.string   "rights_holder_name"
    t.boolean  "downloadable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "category"
    t.string   "display_text"
    t.string   "url"
    t.integer  "asset_id"
    t.string   "asset_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "region"
    t.string   "subregion"
    t.integer  "asset_id"
    t.string   "asset_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",       :limit => {:srid=>4326, :type=>"geometry"}
  end

  create_table "membership_roles", :force => true do |t|
    t.integer  "membership_id"
    t.integer  "role_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "memberships", :force => true do |t|
    t.string   "email"
    t.integer  "setup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "metadata_messages", :force => true do |t|
    t.integer  "granule_file_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mime_type_extensions", :force => true do |t|
    t.string   "extension"
    t.string   "icon"
    t.integer  "mime_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mime_types", :force => true do |t|
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "noted_id"
    t.string   "noted_type"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_assets", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "data_source_id"
    t.integer  "mime_type_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",               :limit => {:no_constraints=>true}
    t.integer  "owner_id"
    t.integer  "source_agency_id"
    t.boolean  "delta",                                                 :default => true, :null => false
    t.integer  "primary_contact_id"
    t.datetime "published_at"
    t.integer  "license_id"
    t.string   "path"
    t.datetime "archived_at"
    t.string   "status"
    t.integer  "funding_agency_id"
  end

  create_table "old_links", :force => true do |t|
    t.string   "display_text"
    t.string   "category",      :null => false
    t.string   "url",           :null => false
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_locations", :force => true do |t|
    t.string   "name"
    t.integer  "feature_id"
    t.string   "region"
    t.string   "subregion"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",           :limit => {:no_constraints=>true}
  end

  add_index "old_locations", ["geom"], :name => "index_locations_on_geom", :spatial => true
  add_index "old_locations", ["locatable_id", "locatable_type"], :name => "as_locatable"

  create_table "old_notes", :force => true do |t|
    t.integer  "project_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_projects", :force => true do |t|
    t.string   "title"
    t.integer  "agency_id"
    t.integer  "parent_id"
    t.integer  "status_id"
    t.integer  "phase_id"
    t.integer  "location_id"
    t.integer  "report_id"
    t.integer  "user_id"
    t.decimal  "budget",                          :precision => 12, :scale => 2
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_url"
    t.string   "year_funded",        :limit => 4
    t.string   "remote_source_id"
    t.integer  "data_source_id"
    t.datetime "published_at"
    t.integer  "published_by"
    t.integer  "owner_id"
    t.string   "status"
    t.integer  "primary_contact_id"
    t.boolean  "delta",                                                          :default => true, :null => false
    t.integer  "source_agency_id"
    t.text     "description"
    t.datetime "archived_at"
    t.integer  "funding_agency_id"
    t.string   "uuid"
  end

  add_index "old_projects", ["id", "published_at"], :name => "project_published_id_index"
  add_index "old_projects", ["published_at"], :name => "index_projects_on_published_at"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "page_contents", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "sections"
    t.text     "content"
    t.string   "layout"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "page_layout_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "redirect"
    t.string   "description"
    t.boolean  "main_menu",      :default => true
    t.string   "menu_icon"
    t.boolean  "draft",          :default => false
    t.integer  "updated_by_id"
  end

  create_table "page_images", :force => true do |t|
    t.integer  "image_id"
    t.integer  "content_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "page_layouts", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "default"
  end

  create_table "page_layouts_setups", :id => false, :force => true do |t|
    t.integer "setup_id"
    t.integer "layout_id"
  end

  create_table "page_snippets", :force => true do |t|
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "page_snippets", ["slug"], :name => "index_page_snippets_on_slug"

  create_table "pages_setups", :id => false, :force => true do |t|
    t.integer "setup_id"
    t.integer "content_id"
  end

  create_table "people", :force => true do |t|
    t.string   "salutation"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
  end

  create_table "persons_setups", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "setup_id"
  end

  add_index "persons_setups", ["person_id"], :name => "index_persons_setups_on_people_id"
  add_index "persons_setups", ["setup_id", "person_id"], :name => "index_persons_setups_on_setup_id_and_people_id"
  add_index "persons_setups", ["setup_id"], :name => "index_persons_setups_on_setup_id"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "person_id"
    t.string   "digits"
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "previews", :force => true do |t|
    t.integer  "catalog_id", :null => false
    t.string   "md5",        :null => false
    t.string   "image",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_agencies", :force => true do |t|
    t.integer  "project_id"
    t.integer  "agency_id"
    t.boolean  "funding",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_contacts", :force => true do |t|
    t.integer  "project_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_geolocations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "geolocation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_locations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_themes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_tags", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "tag_id"
  end

  create_table "repos", :force => true do |t|
    t.string   "repohex",    :null => false
    t.string   "slug",       :null => false
    t.integer  "catalog_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_permissions", :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "setup_id"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setups", :force => true do |t|
    t.string   "primary_color"
    t.string   "title"
    t.string   "by_line"
    t.string   "url"
    t.string   "logo_uid"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "contact_email"
    t.text     "default_invite"
    t.text     "analytics_account"
    t.string   "twitter_url"
    t.string   "github_url"
    t.string   "facebook_url"
  end

  create_table "setups_snippets", :id => false, :force => true do |t|
    t.integer "setup_id"
    t.integer "snippet_id"
  end

  add_index "setups_snippets", ["setup_id", "setup_id"], :name => "index_setups_snippets_on_setup_id_and_setup_id"
  add_index "setups_snippets", ["setup_id"], :name => "index_setups_snippets_on_setup_id"
  add_index "setups_snippets", ["snippet_id"], :name => "index_setups_snippets_on_snippet_id"

  create_table "site_urls", :force => true do |t|
    t.string   "url"
    t.integer  "setup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "site_urls", ["url"], :name => "index_site_urls_on_url"

  create_table "spreadsheet_projects", :id => false, :force => true do |t|
    t.integer "recno"
    t.string  "Yr 1st Funded",                    :limit => 75
    t.string  "Funding Source",                   :limit => 250
    t.string  "funding source acronym",           :limit => 75
    t.string  "Point of Contact",                 :limit => 75
    t.string  "PC Affiliation",                   :limit => 75
    t.string  "PC Phone",                         :limit => 75
    t.string  "PC Email",                         :limit => 75
    t.string  "Other Cooperators",                :limit => 250
    t.string  "other cooperators acronym",        :limit => 250
    t.string  "Theme",                            :limit => 250
    t.string  "Other Theme",                      :limit => 250
    t.string  "Location",                         :limit => 250
    t.string  "Other Location",                   :limit => 250
    t.string  "Keyword",                          :limit => 300
    t.string  "Original Start Date",              :limit => 75
    t.string  "start date as date",               :limit => 75
    t.string  "End Date/ On-Going",               :limit => 75
    t.string  "Title",                            :limit => 250
    t.string  "Synopsis",                         :limit => nil
    t.string  "Report Status",                    :limit => 200
    t.string  "Report Location: Website/Contact", :limit => 300
  end

  create_table "spreadsheet_projects_bup", :id => false, :force => true do |t|
    t.integer "recno"
    t.string  "Yr 1st Funded",                    :limit => 75
    t.string  "Funding Source",                   :limit => 250
    t.string  "funding source acronym",           :limit => 75
    t.string  "Point of Contact",                 :limit => 75
    t.string  "PC Affiliation",                   :limit => 75
    t.string  "PC Phone",                         :limit => 75
    t.string  "PC Email",                         :limit => 75
    t.string  "Other Cooperators",                :limit => 250
    t.string  "other cooperators acronym",        :limit => 250
    t.string  "Theme",                            :limit => 250
    t.string  "Other Theme",                      :limit => 250
    t.string  "Location",                         :limit => 250
    t.string  "Other Location",                   :limit => 250
    t.string  "Keyword",                          :limit => 300
    t.string  "Original Start Date",              :limit => 75
    t.string  "start date as date",               :limit => 75
    t.string  "End Date/ On-Going",               :limit => 75
    t.string  "Title",                            :limit => 250
    t.string  "Synopsis",                         :limit => nil
    t.string  "Report Status",                    :limit => 200
    t.string  "Report Location: Website/Contact", :limit => 300
  end

  create_table "synopses", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "active"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string  "text"
    t.boolean "highlight", :default => false
  end

  create_table "tasks", :force => true do |t|
    t.integer  "target_id"
    t.string   "target_class"
    t.string   "command"
    t.text     "arguments"
    t.boolean  "performed",    :default => false
    t.datetime "performed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["performed"], :name => "tasks_index_tasks_on_performed"

  create_table "themes", :force => true do |t|
    t.string   "name",        :limit => 80
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_agreements", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "required",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "identity_url"
    t.integer  "agency_id"
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "filename"
    t.string   "vidtype",    :default => "Camtasia Flash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
  end

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",       :limit => {:no_constraints=>true}
    t.string   "message"
    t.integer  "sort"
  end

  add_index "zones", ["geom"], :name => "index_zones_on_geom", :spatial => true

end

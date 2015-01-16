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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150114013706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "activity_logs", force: true do |t|
    t.string   "activity"
    t.string   "loggable_type"
    t.integer  "loggable_id"
    t.integer  "user_id"
    t.text     "message"
    t.integer  "entry_id"
    t.integer  "portal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "description"
    t.string   "acronym",     limit: 15
    t.string   "adiwg_code"
    t.string   "adiwg_path"
    t.string   "logo_uid"
    t.string   "logo_name"
    t.string   "url"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aliases", force: true do |t|
    t.string   "text"
    t.integer  "aliasable_id"
    t.string   "aliasable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "entry_id"
    t.string   "file_uid"
    t.integer  "file_size"
    t.string   "file_name"
    t.string   "category"
    t.string   "uuid"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "portal_id"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entry_collections_count", default: 0
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "job_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.string   "slug"
    t.string   "uuid"
    t.integer  "licence_id"
    t.datetime "archived_at"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "use_agreement_id"
    t.boolean  "request_contact_info"
    t.boolean  "require_contact_info"
    t.integer  "entry_type_id"
    t.datetime "published_at"
  end

  create_table "entry_agencies", force: true do |t|
    t.integer  "entry_id"
    t.integer  "agency_id"
    t.boolean  "primary",    default: false
    t.boolean  "funding",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entry_aliases", force: true do |t|
    t.string   "slug"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entry_collections", force: true do |t|
    t.integer  "collection_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entry_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "entry_id"
    t.boolean  "primary",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entry_portals", force: true do |t|
    t.integer  "portal_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "owner"
  end

  create_table "entry_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favicons", force: true do |t|
    t.integer  "portal_id"
    t.string   "image_name"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "portal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "email"
    t.text     "message"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.uuid     "uuid",          default: "uuid_generate_v4()"
    t.integer  "portal_id"
  end

  create_table "links", force: true do |t|
    t.string   "category"
    t.string   "display_text"
    t.string   "url"
    t.integer  "entry_id"
    t.boolean  "valid_link",      default: true
    t.date     "last_checked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "portal_id"
    t.hstore   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portal_urls", force: true do |t|
    t.integer  "portal_id"
    t.string   "url"
    t.boolean  "default",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portals", force: true do |t|
    t.string   "title"
    t.string   "by_line"
    t.string   "acronym"
    t.text     "description"
    t.string   "logo_uid"
    t.string   "contact_email"
    t.string   "analytics_account"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_network_configs", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networks", force: true do |t|
    t.integer  "portal_id"
    t.integer  "social_network_config_id"
    t.string   "url"
    t.boolean  "valid_url",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "use_agreements", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "required",    default: true
    t.integer  "portal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global_admin", default: false
  end

end

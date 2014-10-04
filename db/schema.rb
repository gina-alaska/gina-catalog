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

ActiveRecord::Schema.define(version: 20141004001548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "hstore"

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
    t.boolean  "active",                 default: true
    t.string   "adiwg_code"
    t.string   "adiwg_path"
    t.string   "logo_uid"
    t.string   "logo_name"
    t.string   "url"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agency_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "agency_id"
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
    t.integer  "site_id"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "site_id"
    t.integer  "licence_id"
    t.datetime "archived_at"
    t.integer  "published_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "owner_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "use_agreement_id"
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

  create_table "entry_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "entry_id"
    t.boolean  "primary",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "email"
    t.text     "message"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.hstore   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_urls", force: true do |t|
    t.integer  "site_id"
    t.string   "url"
    t.boolean  "default",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.hstore   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.string   "title"
    t.string   "by_line"
    t.string   "acronym"
    t.text     "description"
    t.string   "url"
    t.string   "logo_uid"
    t.string   "contact_email"
    t.string   "analytics_account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
  end

  create_table "use_agreements", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "required",   default: true
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

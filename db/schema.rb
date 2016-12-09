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

ActiveRecord::Schema.define(version: 20161209042249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.float    "lat"
    t.float    "lon"
    t.string   "street"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "dev_site_id"
    t.float    "geocode_lat"
    t.float    "geocode_lon"
  end

  add_index "addresses", ["lat", "lon", "geocode_lat", "geocode_lon"], name: "index_addresses_on_lat_and_lon_and_geocode_lat_and_geocode_lon", using: :btree

  create_table "city_files", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "orig_created"
    t.datetime "orig_update"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "dev_site_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "dev_site_id"
    t.string   "title"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "event_id"
    t.integer  "vote_count"
  end

  add_index "comments", ["dev_site_id"], name: "index_comments_on_dev_site_id", using: :btree
  add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "topic"
    t.string   "body"
    t.string   "conversation_type"
    t.string   "image"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "dev_sites", force: :cascade do |t|
    t.string   "devID"
    t.string   "application_type"
    t.string   "title"
    t.text     "description"
    t.string   "ward_name"
    t.integer  "ward_num"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "appID"
    t.datetime "received_date"
    t.datetime "updated"
    t.string   "image_url"
    t.integer  "hearts"
    t.json     "files"
    t.json     "images"
    t.string   "build_type"
    t.string   "urban_planner_email"
    t.string   "ward_councillor_email"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "date"
    t.string   "location"
    t.json     "images"
    t.string   "contact_tel"
    t.string   "contact_email"
    t.string   "time"
    t.float    "geocode_lat"
    t.float    "geocode_lon"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dev_site_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "likes", ["dev_site_id"], name: "index_likes_on_dev_site_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "newletter",  default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "neighbourhood"
    t.string   "postal_code"
    t.boolean  "accepted_terms"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "street"
    t.string   "avatar"
    t.string   "city"
    t.string   "age_range"
    t.string   "field_of_occupation"
    t.boolean  "receive_newletter"
    t.text     "bio"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.datetime "status_date"
    t.string   "status"
    t.datetime "created"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "dev_site_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "lived_in_neighborhood"
    t.string   "neighborhood_description"
    t.string   "community_involvement"
    t.string   "biking_infrastructure"
    t.string   "urban_intensification"
    t.string   "heritage"
    t.text     "interesting_neighborhood_topics"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "surveys", ["user_id"], name: "index_surveys_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "role"
    t.text     "bio"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "api_key"
    t.string   "address"
    t.string   "neighbourhood"
    t.string   "organization"
    t.string   "remember_digest"
    t.string   "uid"
    t.string   "provider"
  end

  add_index "users", ["remember_digest"], name: "index_users_on_remember_digest", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "comment_id"
    t.boolean "up"
  end

  add_index "votes", ["comment_id"], name: "index_votes_on_comment_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

  add_foreign_key "comments", "dev_sites"
  add_foreign_key "comments", "events"
  add_foreign_key "conversations", "users"
  add_foreign_key "likes", "dev_sites"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "surveys", "users"
  add_foreign_key "votes", "comments"
  add_foreign_key "votes", "users"
end

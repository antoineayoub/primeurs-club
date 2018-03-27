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

ActiveRecord::Schema.define(version: 20170511132749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "appellations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_appellations_on_region_id"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retailer_stocks", id: :serial, force: :cascade do |t|
    t.integer "retailer_id"
    t.integer "vintage_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["retailer_id"], name: "index_retailer_stocks_on_retailer_id"
    t.index ["vintage_id"], name: "index_retailer_stocks_on_vintage_id"
  end

  create_table "retailers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_stocks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "vintage_id"
    t.float "size_bottles"
    t.integer "nb_bottles"
    t.integer "quantity"
    t.string "regis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_stocks_on_user_id"
    t.index ["vintage_id"], name: "index_user_stocks_on_vintage_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vintages", id: :serial, force: :cascade do |t|
    t.integer "vintage"
    t.text "description"
    t.integer "wine_id"
    t.integer "price"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wine_id"], name: "index_vintages_on_wine_id"
  end

  create_table "wine_notes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "note"
    t.integer "vintage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vintage_id"], name: "index_wine_notes_on_vintage_id"
  end

  create_table "wines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "rating"
    t.text "description"
    t.integer "appellation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appellation_id"], name: "index_wines_on_appellation_id"
  end

  add_foreign_key "appellations", "regions"
  add_foreign_key "retailer_stocks", "retailers"
  add_foreign_key "retailer_stocks", "vintages"
  add_foreign_key "user_stocks", "users"
  add_foreign_key "user_stocks", "vintages"
  add_foreign_key "vintages", "wines"
  add_foreign_key "wine_notes", "vintages"
  add_foreign_key "wines", "appellations"
end

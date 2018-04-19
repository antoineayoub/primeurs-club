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

ActiveRecord::Schema.define(version: 20180419155909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appellations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_appellations_on_region_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "photo"
    t.string "from"
    t.bigint "wine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "imageable_id"
    t.string "imageable_type"
    t.string "photo_upload_url"
    t.index ["imageable_id"], name: "index_photos_on_imageable_id"
    t.index ["wine_id"], name: "index_photos_on_wine_id"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retailers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "vendor_critics", force: :cascade do |t|
    t.string "name"
    t.string "note"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.bigint "vendor_vintage_id"
    t.index ["vendor_vintage_id"], name: "index_vendor_critics_on_vendor_vintage_id"
  end

  create_table "vendor_vintages", force: :cascade do |t|
    t.string "vintage"
    t.text "description"
    t.string "alcohol"
    t.date "best_after"
    t.date "best_before"
    t.date "delivery_date"
    t.integer "price_cents"
    t.string "short_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.bigint "vendor_wine_id"
    t.index ["vendor_wine_id"], name: "index_vendor_vintages_on_vendor_wine_id"
  end

  create_table "vendor_wines", force: :cascade do |t|
    t.string "name"
    t.bigint "appellation_id"
    t.bigint "region_id"
    t.integer "rating"
    t.string "slug"
    t.string "colour"
    t.string "pays"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.text "description"
    t.index ["appellation_id"], name: "index_vendor_wines_on_appellation_id"
    t.index ["region_id"], name: "index_vendor_wines_on_region_id"
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
    t.string "slug"
    t.index ["appellation_id"], name: "index_wines_on_appellation_id"
  end

  add_foreign_key "appellations", "regions"
  add_foreign_key "photos", "wines"
  add_foreign_key "vendor_critics", "vendor_vintages"
  add_foreign_key "vendor_vintages", "vendor_wines"
  add_foreign_key "vendor_wines", "appellations"
  add_foreign_key "vendor_wines", "regions"
  add_foreign_key "vintages", "wines"
  add_foreign_key "wine_notes", "vintages"
  add_foreign_key "wines", "appellations"
end

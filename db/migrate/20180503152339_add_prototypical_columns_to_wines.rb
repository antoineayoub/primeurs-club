# Old tables from db/schema.rb

# create_table "wines", id: :serial, force: :cascade do |t|
#   t.string "name"
#   t.string "rating"
#   t.text "description"
#   t.integer "appellation_id"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.string "slug"
#   t.string "wine_type"
#   t.index ["appellation_id"], name: "index_wines_on_appellation_id"
# end

# create_table "vendor_wines", force: :cascade do |t|
#   t.string "name"
#   t.bigint "appellation_id"
#   t.string "rating"
#   t.string "slug"
#   t.string "colour"
#   t.string "pays"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.string "website"
#   t.text "description"
#   t.string "wine_type"
#   t.index ["appellation_id"], name: "index_vendor_wines_on_appellation_id"
# end

class AddPrototypicalColumnsToWines < ActiveRecord::Migration[5.1]
  def change
    remove_column :wines, :description
    add_columns :wines, :colour
    add_columns :wines, :country
  end
end

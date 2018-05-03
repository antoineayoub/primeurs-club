# Old table from db/schema.rb

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

class RemoveRedundantColumnsFromVendorWines < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_wines, :appellation_id
    remove_column :vendor_wines, :wine_type
    remove_column :vendor_wines, :rating
    remove_column :vendor_wines, :colour
    remove_column :vendor_wines, :pays
  end
end

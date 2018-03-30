class CreateVendorWines < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_wines do |t|
      t.string :name
      t.references :appellation, foreign_key: true, index: true
      t.references :region, foreign_key: true, index: true
      t.integer :rating
      t.string :slug
      t.string :picture_label
      t.string :colour
      t.string :pays

      t.timestamps
    end
  end
end

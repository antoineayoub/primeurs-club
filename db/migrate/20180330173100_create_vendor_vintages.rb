class CreateVendorVintages < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_vintages do |t|
      t.references :wine, foreign_key: true, index: true
      t.string :vintage
      t.text :description
      t.string :alcohol
      t.date :best_after
      t.date :best_before
      t.date :delivery_date
      t.integer :price_cents
      t.string :short_description

      t.timestamps
    end
  end
end

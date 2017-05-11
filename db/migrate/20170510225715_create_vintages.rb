class CreateVintages < ActiveRecord::Migration[5.0]
  def change
    create_table :vintages do |t|
      t.integer :vintage
      t.text :description
      t.references :wine, foreign_key: true, index: true
      t.references :wine_note, foreign_key: true, index: true
      t.integer :public_price
      t.integer :primeur_price
      t.integer :selling_price
      t.timestamps
    end
  end
end

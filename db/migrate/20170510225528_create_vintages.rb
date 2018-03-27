class CreateVintages < ActiveRecord::Migration[5.0]
  def change
    create_table :vintages do |t|
      t.integer :vintage
      t.text :description
      t.references :wine, foreign_key: true, index: true
      t.integer :price
      t.string :status
      t.timestamps
    end
  end
end

class CreateWines < ActiveRecord::Migration[5.0]
  def change
    create_table :wines do |t|
      t.string :name
      t.string :rating
      t.text :description
      t.references :appellation, foreign_key: true, index: true

      t.timestamps
    end
  end
end

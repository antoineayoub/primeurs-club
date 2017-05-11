class CreateUserStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_stocks do |t|
      t.references :user, foreign_key: true, index: true
      t.references :vintage, foreign_key: true, index: true
      t.float :size_bottles
      t.integer :nb_bottles
      t.integer :quantity
      t.string :regis

      t.timestamps
    end
  end
end

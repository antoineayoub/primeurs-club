class CreateRetailerStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :retailer_stocks do |t|
      t.references :retailer, foreign_key: true, index: true
      t.references :vintage, foreign_key: true, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end

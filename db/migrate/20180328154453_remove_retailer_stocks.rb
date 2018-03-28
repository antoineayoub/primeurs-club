class RemoveRetailerStocks < ActiveRecord::Migration[5.1]
  def change
    drop_table :retailer_stocks
  end
end

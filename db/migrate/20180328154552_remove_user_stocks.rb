class RemoveUserStocks < ActiveRecord::Migration[5.1]
  def change
    drop_table :user_stocks
  end
end

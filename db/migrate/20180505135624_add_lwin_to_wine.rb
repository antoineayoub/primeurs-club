class AddLwinToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :lwin, :string
    remove_column :vendor_vintages, :lwin, :string

    add_column :vendor_wines, :gws_id, :string
    remove_column :vendor_vintages, :gws_id, :string
    remove_column :vendor_vintages, :journalist_names, :string
    remove_column :vintages, :lwin, :string
  end
end

class ChangeWineAssociationsInVendors < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_vintages, :wine_id
    add_reference :vendor_vintages, :vendor_wine, foreign_key: true, index: true

    remove_column :vendor_critics, :vintage_id
    add_reference :vendor_critics, :vendor_vintage, foreign_key: true, index: true
  end
end

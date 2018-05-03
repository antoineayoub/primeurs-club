class AddWineToVendorWine < ActiveRecord::Migration[5.1]
  def change
    add_reference :vendor_wines, :wine, foreign_key: true, index: true
    remove_column :vendor_wines, :website
  end
end

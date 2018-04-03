class AddDescriptionToVendorWines < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_wines, :description, :text
  end
end

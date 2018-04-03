class RemovePictureLabelFromVendorWines < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_wines, :picture_label
  end
end

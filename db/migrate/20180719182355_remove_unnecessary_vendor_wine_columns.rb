class RemoveUnnecessaryVendorWineColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_wines, :gws_id
  end
end

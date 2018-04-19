class ChangeVendorWineRatinToString < ActiveRecord::Migration[5.1]
  def change
    change_column :vendor_wines, :rating, :string
  end
end

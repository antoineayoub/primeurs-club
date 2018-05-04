class AddWebsiteToVendorWines < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_wines, :website, :string
  end
end

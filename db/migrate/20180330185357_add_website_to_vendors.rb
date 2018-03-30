class AddWebsiteToVendors < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_wines, :website, :string
    add_column :vendor_vintages, :website, :string
    add_column :vendor_critics, :website, :string
  end
end

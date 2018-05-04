class AddInfoToVendorVitages < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_wines, :wine_type, :string
    add_column :vendor_vintages, :lwin, :string
    add_column :vendor_vintages, :lwin_11, :string
    add_column :vendor_vintages, :gws_id, :string
    add_column :vendor_vintages, :confidence_index, :string
    add_column :vendor_vintages, :journalist_names, :string
    add_column :vendor_vintages, :journalist_count, :string
  end
end

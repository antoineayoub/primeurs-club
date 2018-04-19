class AddExitDateToVendorVintages < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_vintages, :exit_date, :string
  end
end

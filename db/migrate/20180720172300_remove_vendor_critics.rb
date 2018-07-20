class RemoveVendorCritics < ActiveRecord::Migration[5.1]
  def change
    drop_table :vendor_critics

    add_column :critics, :description, :text
  end
end

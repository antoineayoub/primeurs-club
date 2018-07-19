class ReorganizeVintageTables < ActiveRecord::Migration[5.1]
  # `vintages` should store information common to all vintaages, whereas `vendor_vintages` stores
  # information specific to each vendor

  def change
    remove_column :vintages, :price_cents
    remove_column :vintages, :description
    add_column :vintages, :global_wine_score, :float

    remove_column :vendor_vintages, :confidence_index
    remove_column :vendor_vintages, :global_wine_score
    remove_column :vendor_vintages, :lwin_11
  end
end

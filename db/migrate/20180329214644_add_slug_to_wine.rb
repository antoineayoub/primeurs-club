class AddSlugToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :slug, :string
    add_column :wines, :wine_type, :string
    add_column :wines, :gws_id, :string
    add_column :vintages, :lwin, :string
    add_column :vintages, :lwin_11, :string
    add_column :vintages, :confidence_index, :string
  end
end

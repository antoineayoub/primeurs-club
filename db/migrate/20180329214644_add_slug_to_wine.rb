class AddSlugToWine < ActiveRecord::Migration[5.1]
  def change
    add_column :wines, :slug, :string
  end
end

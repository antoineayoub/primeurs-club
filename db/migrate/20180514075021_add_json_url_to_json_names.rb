class AddJsonUrlToJsonNames < ActiveRecord::Migration[5.1]
  def change
    add_column :json_names, :json, :string
  end
end

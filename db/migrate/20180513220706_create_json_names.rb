class CreateJsonNames < ActiveRecord::Migration[5.1]
  def change
    create_table :json_names do |t|
      t.string :name
      t.string :website
      t.timestamps
    end
  end
end

class CreateVendorCritics < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_critics do |t|
      t.references :vintage, foreign_key: true, index: true
      t.string :name
      t.string :note
      t.text :description

      t.timestamps
    end
  end
end

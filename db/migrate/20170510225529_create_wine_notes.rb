    class CreateWineNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :wine_notes do |t|
      t.string :name
      t.string :note
      t.references :vintage, foreign_key: true, index: true
      t.timestamps
    end
  end
end

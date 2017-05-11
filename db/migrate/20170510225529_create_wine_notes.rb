class CreateWineNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :wine_notes do |t|
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end

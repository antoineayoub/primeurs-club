class RenameWineNotes < ActiveRecord::Migration[5.1]
  def change
    rename_table :wine_notes, :critics
  end
end

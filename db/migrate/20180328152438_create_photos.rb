class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string :photo
      t.string :from
      t.references :wine, foreign_key: true, index: true
      t.timestamps
    end
  end
end

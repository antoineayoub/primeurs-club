class AddImageableToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_reference :photos, :imageable, polymorhpic: true, index: true
    add_column :photos, :imageable_type, :string, index: true
  end
end

class RenameTablePhotosImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :photos, :photo, :string
    remove_column :photos, :from, :string
    remove_column :photos, :wine_id, :bigint
    rename_column :photos, :photo_upload_url, :image_url
    rename_table :photos, :images
  end
end

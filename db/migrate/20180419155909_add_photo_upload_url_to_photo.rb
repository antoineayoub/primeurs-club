class AddPhotoUploadUrlToPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :photo_upload_url, :string
  end
end

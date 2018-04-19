class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  # mount_uploader :photo, PhotoUploader

  before_save :upload_photo, if: :will_save_change_to_photo?

  private

  def upload_photo
    photo_uploader = PhotoUploader.new
    photo_uploader.download!(photo)
    photo_uploader.store!(photo_uploader.file)
    Seed::Logger.info("file uploaded: #{photo_uploader.file.path}")
    self.photo_upload_url = photo_uploader.url
  end
end

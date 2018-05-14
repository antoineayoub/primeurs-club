require 'open-uri'

class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true
  mount_uploader :image, ImageUploader
  #before_save :upload_image#, if: :will_save_change_to_photo?

  private

  # def upload_image
  #   image_uploader = ImageUploader.new
  #   image = open()
  #   image_uploader.download!(image)
  #   image_uploader.store!(image_uploader.file)
  #   Seed::Logger.info("file uploaded: #{image_uploader.file.path}")
  #   self.image_upload_url = image_uploader.url
  # end
end

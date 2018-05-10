require 'open-uri'

class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true
  mount_uploader :image, ImageUploader
  #before_save :upload_image#, if: :will_save_change_to_photo?

  private

  def upload_image
    image_uploader = ImageUploader.new
    image = open()
    image_uploader.download!(image)
    image_uploader.store!(image_uploader.file)
    Seed::Logger.info("file uploaded: #{image_uploader.file.path}")
    self.image_upload_url = image_uploader.url
  end
end

# photo_uploader = PhotoUploader.new
# photo_uploader.download!(photo)
# photo_uploader.store!(photo_uploader.file)
# Seed::Logger.info("file uploaded: #{photo_uploader.file.path}")
# self.photo_upload_url = photo_uploader.url

#   uploader = FileUploader.new
#     uploader.store!(attachment)
#     i = Image.new
#     i.image_url = uploader.url
#     i.imageable_type = "Question"
#     i.imageable_id = @question.id
#     i.save

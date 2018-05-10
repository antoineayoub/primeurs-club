class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "wine_label"
  end

  def filename
    self.model.slug+ "." + self.content_type.split("/")[1] if model.class == VendorWine
  end

end

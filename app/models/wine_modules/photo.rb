module WineModules
  module Photo
    def photo_url
      photos.first.photo
    end
  end
end
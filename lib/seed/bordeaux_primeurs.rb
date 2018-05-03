# {
#   "name": "Amiral de Beychevelle",
#   "stamp_image_url": "http://www.bordeaux-primeurs.net/images/amiral_de_beychevelle.jpg",
#   "appellation": "Saint-Julien",
#   "rating": "Second vin du Chateau Beychevelle",
#   "colour": "Vin rouge",
#   "description": "Amiral de Beychevelle est un vin rouge issu de vignes plantées dans l'aire de l'appellation Saint...
#   "vintages": [
#     {
#       "year": "2010",
#       "price": "17.95"
#     },
#   ]
# }

module Seed
  class BordeauxPrimeurs < Seed::Base
    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:rating],
        description: wine_attributes[:description],
        colour: wine_attributes[:colour],
        appellation: appellation_object
      }

      vendor_wine = VendorWine.conditionally_create(attributes, Seed::Logger)

      if vendor_wine.persisted?
        photo = Photo.conditionally_create(
          { imageable: vendor_wine, photo: wine_attributes[:stamp_image_url] },
          Seed::Logger
        )
      end

      vendor_wine
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:year],
          price_cents: format_vintage_price(vintage_attributes[:price]),
          vendor_wine: wine_object
        }

        VendorVintage.conditionally_create(attributes, Seed::Logger)
      end
    end

    def format_vintage_price(price_string)
      (price_string.to_f * 100).to_i
    end

    def website_name
      "bordeaux_primeurs"
    end
  end
end

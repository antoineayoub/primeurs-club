# {
#   "wine_details": [
#     {
#       "name": "\"Y\" d'Yquem 2005",
#       "type": "Caisse bois de 6 bouteilles (75cl)",
#       "pays": "France",
#       "region": "Bordeaux",
#       "appellation": "bordeaux blanc",
#       "classement": "2nd vin",
#       "superficie": null,
#       "age_moyen_des_vignes": null,
#       "vin_liquoreux": null,
#       "sols_et_sous_sols": null,
#       "image_url": null,
#       "elevage": "en barriques neuves à 30% durant 10 mois",
#       "vintages": [
#         {
#           "description": null,
#           "price": 13500,
#           "encepagement": "sémillon 75% - sauvignon 25%",
#           "citation": null,
#           "year": 2014
#         },
#         {
#           "description": null,
#           "price": 13800,
#           "encepagement": "sémillon 75% - sauvignon 25%",
#           "citation": null,
#           "year": 2012
#         }
#       ]
#     },
#     {
#       "name": "Aile d'Argent 2008",
#       "type": "Caisse bois de 6 bouteilles (75cl)",
#       "pays": "France",
#       "region": "Bordeaux",
#       "appellation": "bordeaux blanc",
#       "classement": "2nd vin",
#       "superficie": "4 ha",
#       "age_moyen_des_vignes": null,
#       "vin_liquoreux": null,
#       "sols_et_sous_sols": null,
#       "image_url": null,
#       "elevage": null,
#       "vintages": [
#       {
#         "description": null,
#         "price": 6400,
#         "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#         "citation": null,
#         "year": 2017
#       },
#       {
#         "description": null,
#         "price": 7600,
#         "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#         "citation": null,
#         "year": 2014
#       },
#       {
#         "description": null,
#         "price": 6800,
#         "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#         "citation": null,
#         "year": 2011
#       },
#       {
#         "description": null,
#         "price": 7500,
#         "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#         "citation": null,
#         "year": 2009
#         }
#       ]
#     }
#   ]
# }

require "open-uri"

module Seed
  class LaGrandeCave < Seed::Base
    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:classement],
        appellation: appellation_object,
        country: wine_attributes[:pays]
      }

      vendor_wine = VendorWine.find_by_slug_or_create(attributes)

      if vendor_wine.persisted? && photo_upload?
        # image_uploader = ImageUploader.new(vendor_wine)
        # image = open(wine_attributes[:image_url])
        # image_uploader.store!(image)
        # Seed::Logger.info("file uploaded: #{image_uploader.url}")
        # Image.find_or_create_by(imageable_type: "VendorWine", imageable: vendor_wine, image_url: image_uploader.url )
      end

      vendor_wine
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:year],
          description: vintage_attributes[:description],
          price_cents: vintage_attributes[:price],
          # citation: vintage_attributes[:citation], # OwO what's that?
          vendor_wine: wine_object
        }

        vintage = VendorVintage.create_or_update_price(attributes)
        # build_vendor_critics_for_vintage(vintage, vintage_attributes)
      end
    end

    def website_name
      "la_grande_cave"
    end
  end
end

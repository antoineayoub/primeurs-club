# "wine": {
#         "name": "Chateau Maucaillou",
#         "description": "Un Moulis 2014 Delicat Le chateau Maucaillou 2014 semble de prime abord timide dès les prem...
#         "image_url": "https://static.millesima.com/s3/attachements/full/1464_2014NM_c.png",
#         "pays": "france",
#         "region": "bordeaux",
#         "appellation": "moulis",
#         "classement": null,
#         "vignoble": "medoc",
#         "mention_qualite": "aoc",
#         "producteur": "chateau_maucaillou",
#         "couleur": "rouge",
#         "vin_liquoreux": "non",
#         "alcool": "13"
#       },
#       "vintages": [
#         {
#           "year": "2014",
#           "price": 4500,
#           "P": "91",
#           "JR": "15",
#           "WS": "87-90",
#           "RG": "15",
#           "JS": "93"
#         }
#       ]
#      }

module Seed
  class Millesima < Seed::Base
    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:classement],
        description: wine_attributes[:description],
        colour: wine_attributes[:couleur],
        appellation: appellation_object,
        country: wine_attributes[:pays]
      }

      vendor_wine = VendorWine.find_by_slug_or_create(attributes)

      if vendor_wine.persisted? && photo_upload?
        Photo.find_or_create_by(imageable: vendor_wine, photo: wine_attributes[:image_url]) 
      end

      vendor_wine
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:year],
          description: wine_object.description,
          price_cents: format_vintage_price(vintage_attributes[:price]),
          alcohol: wine_attributes[:alcool],
          vendor_wine: wine_object
        }

        vintage = VendorVintage.create_or_update_price(attributes)
        build_vendor_critics_for_vintage(vintage, vintage_attributes)
      end
    end

    def build_vendor_critics_for_vintage(vintage_object, vintage_attributes)
      raters = [:P, :JR, :WS, :RG, :JS]
      raters.each do |rater|
        attributes = {
          website: website_name,
          name: rater.to_s,
          note: vintage_attributes[rater],
          vendor_vintage: vintage_object
        }

        VendorCritic.find_or_create_by(attributes)
      end
    end

    def format_vintage_price(price_string)
      price_string.nil? ? nil : price_string.to_f.to_i
    end

    def website_name
      "millesima"
    end
  end
end

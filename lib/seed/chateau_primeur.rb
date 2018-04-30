# {
#       "region": "Bordeaux",
#       "appellation": "Saint-Emilion Grand Cru",
#       "wine_name": "Château Valandraud",
#       "wine_slug": "chateau_valandraud",
#       "rating": "1er Grand Cru Classé B",
#       "status": "launched",
#       "price": 11500,
#       "delivery_date": "Livraison 1er semestre 2020",
#       "description": "Le Château Valandraud a vu le jour très récemment au début des années 1990, créé par le charismatique et ambitieux Jean-Luc Thunevin. De 60 ares de vignoble à l’origine, le domaine s’est progressivement étendu à 10 hectares aujourd’hui, planté en merlot (70%) et cabernet-franc (25%), avec une touche de cabernet-sauvignon et de malbec.Très séducteur à ses débuts, dans un style opulent et épicé, le vin de Valandraud évolue vers un profil moins moderne dans les derniers millésimes, avec des tanins plus fins et plus fermes. Son potentiel de garde en est encore meilleur.Le Second vin du Château est Virginie de Valandraud.\r\n                Le millésime 2017 vu par la propriété  Assemblage : 90% merlot, 10% cabernet franc  Elevage : 24 à 36 mois en barriques 100% neuves",
#       "bottling": [
#         {
#           "bottling": "1 Bouteille de 75 cl (carton neutre)",
#           "price": 115.0,
#           "extra_charge": "Offert"
#         },
#         {
#           "bottling": "1 Bouteille de 75 cl",
#           "price": 115.0,
#           "extra_charge": "2,75 €"
#         },
#         {
#           "bottling": "6 Bouteilles de 75 cl",
#           "price": 690.0,
#           "extra_charge": "Offert"
#         },
#         {
#           "bottling": "12 Bouteilles de 75 cl",
#           "price": 1.0,
#           "extra_charge": "Offert"
#         },
#         {
#           "bottling": "1 Magnum de 150 cl",
#           "price": 230.0,
#           "extra_charge": "4,60 €"
#         },
#         {
#           "bottling": "1 Magnum de 150 cl (carton neutre)",
#           "price": 230.0,
#           "extra_charge": "Offert"
#         },
#         {
#           "bottling": "3 Magnums de 150 cl",
#           "price": 690.0,
#           "extra_charge": "7,80 €"
#         },
#         {
#           "bottling": "6 Magnums de 150 cl",
#           "price": 1.0,
#           "extra_charge": "Offert"
#         },
#         {
#           "bottling": "1 Double Magnum de 300 cl",
#           "price": 460.0,
#           "extra_charge": "36,00 €"
#         },
#         {
#           "bottling": "1 Impériale de 600 cl",
#           "price": 920.0,
#           "extra_charge": "50,00 €"
#         }
#       ],
#       "wine_critic": [
#         {
#           "wine_critic_name": "J. Suckling",
#           "wine_note": "93-94/100"
#         },
#         {
#           "wine_critic_name": "Wine Spectator",
#           "wine_note": "93-96/100"
#         },
#         {
#           "wine_critic_name": "JM Quarin",
#           "wine_note": "95/100"
#         },
#         {
#           "wine_critic_name": "Wine Enthusiast",
#           "wine_note": "95-97/100"
#         }
#       ],
#       "other_wine": [

#       ]
#     }

module Seed
  class ChateauPrimeur < Seed::Base
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

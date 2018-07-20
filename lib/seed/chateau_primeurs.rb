# {
#     "region": "Bordeaux",
#     "appellation": "Margaux",
#     "name": "Château Labégorce",
#     "wine_slug": "chateau-labegorce",
#     "rating": "",
#     "status": "launched",
#     "price": 2000,
#     "delivery_date": "Livraison 1er semestre 2020",
#     "description": "Propriété de la famille Perrodo, sous la direction de Marjolaine Maurice-de-Coninck, le Château Labégorce est une référence renommée de l’appellation Margaux. Lui et le Château Labégorce-Zédé sont désormais réunis sous une seule étiquette depuis le millésime 2009. Sur un terroir de graves et de cailloux, dont une zone très riche en limons, les 70 hectares de vignes sont plantés de cabernet-sauvignon à 50% et de merlot à 40%, complétés par du cabernet franc et du petit verdot.Pouvant se garder une vingtaine d’années, les vins de Labégorce évoquent un peu ceux de Saint-Estèphe, avec leur style racé, tannique et suave à la fois.\r\n\"Construire une marque, produire un grand vin et permettre au consommateur de se régaler... C'est notre souhait, notre job et avant tout un travail d’équipe de la part de la propriété avec ses négociants. La propriété fait totalement confiance aux équipes de la maison DUCLOT qui, via le site CHATEAUPRIMEUR, savent plébisciter notre marque, raconter son ADN, la faire vivre et la faire aimer !\"  Marjolaine Maurice-de Coninck, Château Labégorce , Margaux ; Château Marquis d'Alesme, Margaux",
#     "bottling": [
#       {
#         "bottling": "6 Bouteilles de 75 cl",
#         "price": 12400.0,
#         "extra_charge": 0.0
#       },
#       {
#         "bottling": "12 Bouteilles de 75 cl",
#         "price": 24900.0,
#         "extra_charge": 0.0
#       },
#       {
#         "bottling": "12 Demi bouteilles de 37,5 cl",
#         "price": 12400.0,
#         "extra_charge": 1200.0
#       },
#       {
#         "bottling": "24 Demi bouteilles de 37,5 cl",
#         "price": 24900.0,
#         "extra_charge": 1900.0
#       },
#       {
#         "bottling": "3 Magnums de 150 cl",
#         "price": 12400.0,
#         "extra_charge": 700.0
#       },
#       {
#         "bottling": "6 Magnums de 150 cl",
#         "price": 24900.0,
#         "extra_charge": 0.0
#       },
#       {
#         "bottling": "1 Double Magnum de 300 cl",
#         "price": 8300.0,
#         "extra_charge": 3600.0
#       },
#       {
#         "bottling": "1 Impériale de 600 cl",
#         "price": 16600.0,
#         "extra_charge": 5000.0
#       },
#       {
#         "bottling": "1 Salmanazar de 900 cl",
#         "price": 24900.0,
#         "extra_charge": 9000.0
#       },
#       {
#         "bottling": "1 Balthazar de 1200 cl",
#         "price": 33200.0,
#         "extra_charge": 10900.0
#       }
#     ],
#     "wine_critic": [
#       {
#         "wine_critic_name": "Decanter",
#         "wine_note": "92/100"
#       },
#       {
#         "wine_critic_name": "Wine Spectator",
#         "wine_note": "90-93/100"
#       },
#       {
#         "wine_critic_name": "J. Suckling",
#         "wine_note": "92-93/100"
#       },
#       {
#         "wine_critic_name": "Wine Enthusiast",
#         "wine_note": "89-91/100"
#       },
#       {
#         "wine_critic_name": "RVF",
#         "wine_note": "16-16/20"
#       }
#     ],
#     "other_wine": [
#       {
#         "wine_slug": "chateau-fombrauge"
#       },
#       {
#         "wine_slug": "chateau-clos-de-bouard"
#       },
#       {
#         "wine_slug": "chateau-bastor-lamontagne"
#       },
#       {
#         "wine_slug": "chateau-labegorce"
#       },
#       {
#         "wine_slug": "chateau-coutet"
#       }
#     ]
#   }

module Seed
  class ChateauPrimeurs < Seed::Base
    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:rating],
        description: wine_attributes[:description],
        appellation: appellation_object
      }

      vendor_wine = VendorWine.find_by_slug_or_create(attributes)

      Image.find_or_create_by(imageable: vendor_wine, image_url: wine_attributes[:stamp_image_url]) if vendor_wine.persisted?
      
      vendor_wine
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      attributes = {
        website: website_name,
        vintage: "2017",
        price_cents: wine_attributes[:price],
        vendor_wine: wine_object
      }

      VendorVintage.create_or_update_price(attributes)

    end

    def website_name
      "chateau_primeur"
    end
  end
end

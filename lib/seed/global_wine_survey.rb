# {
#   "wine": "Chateau Margaux, Margaux",
#   "wine_id": 39051,
#   "wine_slug": "chateau-margaux-margaux",
#   "appellation": "Margaux",
#   "appellation_slug": "margaux",
#   "color": "Red",
#   "wine_type": "",
#   "regions": [
#     "Bordeaux"
#   ],
#   "country": "France",
#   "classification": "1er Grand Cru Classé en 1855",
#   "vintage": "2000",
#   "date": "2018-06-01",
#   "is_primeurs": false,
#   "score": 98.7,
#   "confidence_index": "A",
#   "journalist_count": 9,
#   "lwin": 1012781,
#   "lwin_11": 10127812000
# }

module Seed
  class GlobalWineSurvey < Seed::Base
    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:classification],
        colour: wine_attributes[:color],
        appellation: appellation_object,
        country: wine_attributes[:country]
      }

      VendorWine.find_by_slug_or_create(attributes)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      attributes = {
        vendor_wine: wine_object,
        vintage: wine_attributes[:vintage],
        global_wine_score: wine_attributes[:score],
        gws_id: wine_attributes[:wine_id],
        lwin: wine_attributes[:lwin],
        lwin_11: wine_attributes[:lwin_11],
        journalist_count: wine_attributes[:journalist_count],
        confidence_index: wine_attributes[:confidence_index],
        website: website_name
      }

      VendorVintage.create_or_update_price(attributes)
    end

    def website_name
      "global_wine_survey"
    end
  end
end

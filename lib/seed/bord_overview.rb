module Seed
  class BordOverview < Seed::Base
    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:rating],
        appellation: appellation_object
      }

      VendorWine.find_by_slug_or_create(attributes)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:year],
          price_cents: format_vintage_price(vintage_attributes[:price]),
          vendor_wine: wine_object
        }

        vintage = VendorVintage.create_or_update_price(attributes)
        build_vendor_critics_for_vintage(vintage, vintage_attributes)
      end
    end

    def build_vendor_critics_for_vintage(vintage_object, vintage_attributes)
      raters = [:RP, :NM, :JR, :TA, :"B&D", :JS, :JL, :De, :RVF, :JA, :LeP, :PW, :RG]
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

    def website_name
      "bord_overview"
    end

    def format_vintage_price(price)
      price.is_a?(String) ? price.gsub(/\D/, "") : nil
    end
  end
end

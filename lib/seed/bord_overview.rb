module Seed
  class BordOverview < Seed::Base
    private

    def run
      @wine_details.each do |wine_attributes|
        begin
          appellation = Appellation.find_or_create_by(name: wine_attributes[:appellation])
          wine = build_wine_with_appellation(appellation, wine_attributes)
          build_vendor_vintages_for_wine(wine, wine_attributes)
        rescue => e
          Seed::Logger.error(e)
        end
      end
    end

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:rating],
        appellation: appellation_object
      }

      VendorWine.conditionally_create(attributes, Seed::Logger)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:year],
          price_cents: format_vintage_price(vintage_attributes[:price]),
          vendor_wine: wine_object
        }

        vintage = VendorVintage.conditionally_create(attributes, Seed::Logger)
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

        VendorCritic.conditionally_create(attributes, Seed::Logger)
      end
    end

    def website_name
      "bord overview"
    end

    def timestamp_of_file(file_name)
      file_name.split("/").last.split("_").first.to_i
    end

    def format_vintage_price(price)
      price.is_a?(String) ? price.gsub(/\D/, "") : nil
    end
  end
end

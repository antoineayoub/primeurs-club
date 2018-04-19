# {
#   "Couleur": "Rouge",
#   "Appellation": "Médoc",
#   "Classement": null,
#   "Chateau": "AIR DE VIEUX ROBIN",
#   "vintages": [
#     {
#       "Année": "2006",
#       "Date de Sortie": "03/05/2007",
#       "PRC": "5,25",
#       "Wine Advocate": null
#     }
#   ]
# }

module Seed
  module TastetClassMethods
    def generate_json_file
      file_path = "#{Rails.root}/db/scraper/tastet_primeurs.csv"
      options = { col_sep: ";", headers: :first_row, encoding: "ISO8859-1" }
      csv = CSV.read(file_path, options).map(&:to_h).map(&:symbolize_keys)
      
      output_hash = csv.group_by { |row| row[:Chateau] }.map(&:last).map do |wines|
        wine = wines.first.slice(:Couleur, :Appellation, :Classement, :Chateau)
        rename_wine_hash_keys!(wine)
        wine[:vintages] = wines.map { |vintage| vintage.slice(:Année, :"Date de Sortie", :PRC, :"Wine Advocate") }
        wine
      end
  
      output_file_path = Rails.root.join("db/scraper/#{DateTime.now.strftime('%Y%m%d%H%M%S')}_tastet_lawton.json")
      stringified_json = JSON.pretty_generate({ wine_details: output_hash })
      
      File.open(output_file_path, "w") do |file|
        file.write(stringified_json)
      end
    end
    
    private
    
    def rename_wine_hash_keys!(wine_hash)
      lookup = {
        Appellation: :appellation,
        Chateau: :name,
      }
      
      lookup.each do |original_name, new_name|
        wine_hash[new_name] = wine_hash.delete(original_name)
      end
    end
  end
  class Tastet < Seed::Base
    extend TastetClassMethods

    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:Classement],
        colour: wine_attributes[:Couleur],
        appellation: appellation_object
      }

      VendorWine.conditionally_create(attributes, Seed::Logger)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        attributes = {
          website: website_name,
          vintage: vintage_attributes[:Année],
          exit_date: vintage_attributes[:"Date de Sortie"],
          price_cents: format_vintage_price(vintage_attributes[:PRC]),
          vendor_wine: wine_object
        }

        vintage = VendorVintage.conditionally_create(attributes, Seed::Logger)
        build_vendor_critics_for_vintage(vintage, vintage_attributes)
      end      
    end

    def build_vendor_critics_for_vintage(vintage_object, vintage_attributes)
      attributes = {
        website: website_name,
        name: "Wine Advocate",
        note: vintage_attributes[:"Wine Advocate"],
        vendor_vintage: vintage_object
      }

      VendorCritic.conditionally_create(attributes, Seed::Logger)
    end

    def format_vintage_price(price_string)
      price_string.nil? ? nil : (price_string.gsub(",", ".").to_f * 100).to_i
    end

    def website_name
      "tastet_lawton"
    end
  end
end

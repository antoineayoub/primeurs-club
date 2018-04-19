module Seed
  class Tastet < Seed::Base
    def self.generate_json_file
      file_path = "#{Rails.root}/db/scraper/tastet_primeurs.csv"
      options = { col_sep: ";", headers: :first_row, encoding: "ISO8859-1" }
      csv = CSV.read(file_path, options).map(&:to_h).map(&:symbolize_keys)
      
      output_hash = csv.group_by { |row| row[:Chateau] }.map(&:last).map do |wines|
        wine = wines.first.slice(:Couleur, :Appellation, :Classement, :Chateau)
        wine[:vintages] = wines.map { |vintage| vintage.slice(:Année, :"Date de Sortie", :PRC, :"Wine Advocate") }
        wine
      end

      output_file_path = Rails.root.join("db/scraper/#{DateTime.now.strftime('%Y%m%d%H%M%S')}_tastet.json")
      stringified_json = JSON.pretty_generate({ wine_details: output_hash })

      File.open(output_file_path, "w") do |file|
        file.write(stringified_json)
      end
    end

    private

    def build_wine_with_appellation(appellation_object, wine_attributes)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
    end

    def build_vendor_critics_for_vintage(vintage_object, vintage_attributes)
    end

    def format_vintage_price(price_string)
    end

    def website_name
    end
  end
end

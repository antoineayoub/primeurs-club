module Scraper
  module Wine
    class MillesimaVintage < Base
      attr_writer :price

      set_attributes :year, :price, :P, :JR, :WS, :RG, :JS

      before_scraping :build_details_hash

      def year
        dom.search(".main_header").first.text.match(/\d*\z/)[0]
      end

      def price
      end

      def P
        @details_hash[:P]
      end

      def JR
        @details_hash[:JR]
      end

      def WS
        
        @details_hash[:WS]
      end

      def RG
        @details_hash[:RG]
      end
      
      def JS
        @details_hash[:JS]
      end
      
      private
      
      def build_details_hash
        words = dom.search(".descriptiveAttributes tr > td").map do |td|
          td.text.strip
        end

        @details_hash = format_attribute_names(words.each_slice(2).to_a.to_h)
      end
      
      def format_attribute_names(hash)
        name_conversion_lookup = {
          "parker" => :P,
          "wine_spectator" => :WS,
          "j._robinson" => :JR,
          "j._suckling" => :JS,
          "r._gabriel" => :RG
        }

        formatted = hash.map do |key, value|
          key = key.downcase.gsub(/(é|è)/, "e").gsub(/\s/, "_")
          key = name_conversion_lookup[key] ? name_conversion_lookup[key] : key
          key = key.to_sym

          [key, value]
        end

        formatted.to_h
      end
    end
  end
end
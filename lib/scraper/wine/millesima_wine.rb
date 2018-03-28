module Scraper
  module Wine
    class MillesimaWine < Wine::Base
      set_attributes(
        :name, :description, :image_url, :pays,
        :region, :appellation, :classement,
        :vignoble, :mention_qualite, :producteur,
        :couleur, :vin_liquoreux, :alcool
      )

      before_scraping :build_details_hash

      def name
        dom.search(".main_header").first.text.match(/(^[\D\s]*)\s\d/)[1]
      end

      def description
        dom.search("div[itemprop='description']").first.text.match(/\A(.*)(Wine Advocate\-Parker.*)\z/)[1]
      end

      def image_url
        dom.search("#productMainImage").first.attributes["src"].value
      end

      def pays
        @details_hash[:pays]
      end

      def region
        @details_hash[:region]
      end

      def appellation
        @details_hash[:appellation]
      end

      def classement
        @details_hash[:classement]
      end

      def vignoble
        @details_hash[:vignoble]
      end

      def mention_qualite
        @details_hash[:mention_qualite]
      end

      def producteur
        @details_hash[:producteur]
      end

      def couleur
        @details_hash[:couleur]
      end

      def vin_liquoreux
        @details_hash[:vin_liquoreux]
      end

      def alcool
        @details_hash[:alcool]
      end

      private

      def build_details_hash
        words = dom.search(".descriptiveAttributes > tr > td").map do |td|
          td.text.strip.downcase.gsub(/(é|è)/, "e").gsub(/\s/, "_")
        end

        @details_hash = words.each_slice(2).to_a.to_h.symbolize_keys
      end
    end
  end
end
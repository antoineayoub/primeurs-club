module Scraper
  module Wine
    class LaGrandeCaveWine < Wine::Base
      set_attributes(
        :wine_slug, :name, :description, :image_url,
        :citation ,:appellation, :superficie, :encepagement,:classement,
        :age_moyen_des_vignes , :sols_et_sous_sols, :elevage
      )

      before_scraping :build_details_hash

      def wine_slug
      end

      def name
      end

      def description
      end

      def image_url
      end

      def citation
      end

      def pays
        "France"
      end

      def region
        "Bordeaux"
      end

      def appellation
        @details_hash[:appellation]
      end

      def classement
        @details_hash[:classement]
      end

      def superficie
        @details_hash[:superficie]
      end

      def encepagement
        @details_hash[:encepagement]
      end

      def age_moyen_des_vignes
        @details_hash[:age_moyen_des_vignes]
      end

      def elevage
        @details_hash[:elevage]
      end

      def vin_liquoreux
        @details_hash[:vin_liquoreux]
      end

      private

      def build_details_hash(dom)
        words = dom.search("#details tr").map do |tr|
          [tr.children[1].text.strip.downcase.gsub(/(é|è)/, "e").gsub(/\s/, "_"),
          tr.children[3].text.strip.downcase]
        end

        @details_hash = words.to_h.symbolize_keys
      end
    end
  end
end

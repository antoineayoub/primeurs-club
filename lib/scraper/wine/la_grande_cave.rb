module Scraper
  module Wine
    class LaGrandeCave < Wine::Base
      set_attributes(
        :name, :type, :description, :price, :pays, :region, :appellation,
        :classement, :superficie, :encepagement, :age_moyen_des_vignes,
        :elevage, :vin_liquoreux, :image_url, :citation, :age_moyen_des_vignes,
        :sols_et_sous_sols, :vintages
      )

      before_scraping :retrieve_wine_page_dom, :build_details_hash

      def name
        dom.search(".nom_vin > h2 .up").text.strip
      end

      def type         
        dom.search(".contenance_vin").text.strip
      end

      def description
        dom.search('#millesimes').first&.text&.strip
      end

      def price
        css_selector = type == 'Primeur' ? ".prix_vin" : ".prix_unite > strong"
        dom.search(css_selector).text.strip.gsub(/\s€\s*/,"").to_f.*(100).to_i
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

      # TODO

      # A CSS selector that'll I'll apparently need: "#notations tr"

      def image_url
      
      end

      def citation
      
      end

      def age_moyen_des_vignes
      
      end

      def sols_et_sous_sols
      
      end

      def vintages
      
      end

      private

      def retrieve_wine_page_dom
        wine_page_url = dom.search('.infos > a').attribute('href').value
        @wine_page_dom = dom_from_url(wine_page_url)
      end

      def build_details_hash
        words = @wine_page_dom.search("#details tr").map do |tr|
          [tr.children[1].text.strip.downcase.gsub(/(é|è)/, "e").gsub(/\s/, "_"),
          tr.children[3].text.strip.downcase]
        end

        @details_hash = words.to_h.symbolize_keys
      end
    end
  end
end

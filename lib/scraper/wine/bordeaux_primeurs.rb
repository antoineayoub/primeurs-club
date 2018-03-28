module Scraper
  module Wine
    class BordeauxPrimeurs < Base
      set_attributes :name, :stamp_image_url, :appellation, :rating, :colour, :description, :vintages

      def name
        date.search("h2").first.inner_html
      end

      def stamp_image_url
        BordeauxPrimeurs.base_url + date.search("td[width='45%'] > img").first.attributes["src"].value
      end

      def appellation
        date.search("div > center").last.children.first.text
      end

      def rating
        date.search("div > center").last.children[3].text
      end

      def colour
        date.search("div > center").last.children.last.text
      end

      def description
        date.search("table[width='95%'] > tr > td > font").first.text.strip
      end

      def vintages
        rows = date.search("table[width='100%'][cellspacing='1'][cellpadding='0'][bgcolor='#CCCCCC']")

        combined = rows.each_with_object({ years: [], prices: []}) do |row, hash|
          row.search("b").map(&:text).each { |year| hash[:years] << year }
          row.search("center > center").map(&:text).each { |price| hash[:prices] << price }
        end

        total_vintages = []
        combined[:years].length.times do |i|
          price = combined[:prices][i] == "..." ? Scraper::Base:Base.null_value : combined[:prices][i]
          
          total_vintages << { year: combined[:years][i], price: price }
        end
        
        total_vintages
      end
    end
  end
end
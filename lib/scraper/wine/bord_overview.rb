module Scraper
  module Wine
    class BordOverview < Wine::Base
      set_attributes :name, :appellation, :rating, :vintages
      
      def name
        dom.first.children.first.text.gsub(/\(buy\)$/, "").strip
      end
      
      def appellation
        dom.first.children[2].text
      end
      
      def rating
        dom.first.children[3].text
      end
      
      def vintages
        dom.map do |row| 
          row_as_hash = Scraper::BordOverview.headers.zip(extract_values_of_row(row)).to_h
          (BordOverview.attributes - [:vintages]).each { |attribute| row_as_hash.delete(attribute) }
          row_as_hash
        end
      end

      private

      def extract_values_of_row(row)
        valid_columns = row.children.select do |column|
          column.attributes["class"].nil? || !["cMB", "cCK"].include?(column.attributes["class"].value)
        end

        valid_columns.map(&:text).map do |columns_value| 
          columns_value == "·" ? Scraper::Base.null_value : columns_value
        end
      end
    end
  end
end
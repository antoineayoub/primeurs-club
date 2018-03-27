module Scraper
  class Wine
    def self.build_from_dom(dom)
      new(dom)
    end

    def initialize(dom)
      @attributes = [
        :name,
        :stamp_image_url,
        :appellation,
        :rating,
        :colour,
        :description,
        :vintages
      ]

      @dom = dom

      collect_all_attributes
    end

    def to_hash
      @attributes.each_with_object({}) do |attribute, hash|
        hash[attribute] = instance_variable_get("@#{attribute}")
      end
    end

    private

    def collect_all_attributes
      @attributes.each do |attribute|
        begin
          instance_variable_set("@#{attribute.to_s}", send(attribute))
        rescue NoMethodError
          instance_variable_set("@#{attribute.to_s}", BordeauxPrimeurs.null_value)
        end
      end
    end

    def name
      @dom.search("h2").first.inner_html
    end

    def stamp_image_url
      BordeauxPrimeurs.base_url + @dom.search("td[width='45%'] > img").first.attributes["src"].value
    end

    def appellation
      @dom.search("div > center").last.children.first.text
    end

    def rating
      @dom.search("div > center").last.children[3].text
    end

    def colour
      @dom.search("div > center").last.children.last.text
    end

    def description
      @dom.search("table[width='95%'] > tr > td > font").first.text.strip
    end

    def vintages
      rows = @dom.search("table[width='100%'][cellspacing='1'][cellpadding='0'][bgcolor='#CCCCCC']")

      combined = rows.each_with_object({ years: [], prices: []}) do |row, hash|
        row.search("b").map(&:text).each { |year| hash[:years] << year }
        row.search("center > center").map(&:text).each { |price| hash[:prices] << price }
      end

      total_vintages = []
      combined[:years].length.times do |i|
        price = combined[:prices][i] == "..." ? BordeauxPrimeurs.null_value : combined[:prices][i]
        
        total_vintages << { year: combined[:years][i], price: price }
      end
      
      total_vintages
    end
  end
end
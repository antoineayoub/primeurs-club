module Scraper
  class Millesima < Base
    set_base_url "https://www.millesima.fr"
    set_output_file "millesima.json"    

    def run
      @output_hash[:wine_slugs] = collect_all_wine_slugs
    end

    private

    def collect_all_wine_slugs
      document_object_model = dom_from_url(Rails.root.join("db/html/millesima.html"))
      links = document_object_model.search(".product_name > a")
      names = links.map do |link| 
        name = link.attributes["href"].value.split("/").last.split(".").first
        @logger.info(name)
        name
      end

      names.sort
    end
  end
end

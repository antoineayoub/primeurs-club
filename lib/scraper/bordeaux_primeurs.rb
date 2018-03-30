module Scraper
  class BordeauxPrimeurs < Base
    set_base_url "http://www.bordeaux-primeurs.net"
    set_output_file "bordeaux_primeurs.json"

    def run
      @output_hash[:wine_slugs] = collect_all_wine_slugs
      collect_details_of_each_wine
    end
    
    private
    
    def collect_all_wine_slugs
      document_object_model = dom_from_url(BordeauxPrimeurs.base_url + "/vins-primeurs.php")
      links = document_object_model.search("a > font")[1..-1]
      links.map { |link| link.parent.attributes["href"].value.split(".").first }
    end

    def collect_details_of_each_wine
      @output_hash[:wine_details] = []

      @output_hash[:wine_slugs][1..-1].each do |wine_slug|
         wine_details = collect_wine_details(wine_slug)
         @logger.info(wine_slug)
         @output_hash[:wine_details] << wine_details
      end
    end

    def collect_wine_details(wine_slug)
      document_object_model = dom_from_url(BordeauxPrimeurs.base_url + "/#{wine_slug}.php")
      Wine::BordeauxPrimeurs.build_from_dom(document_object_model).to_hash
    rescue Interrupt, SignalException
      save_and_exit 
    rescue => e
      @logger.fatal(e)
      Scraper::Base.null_value
    end
  end
end
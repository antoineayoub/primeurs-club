module Scraper
  class LaGrandeCave < Base
    set_base_url "https://www.lagrandecave.fr/tousNosVins?format=1"
    set_output_file "la_grande_cave.json"

    def collect_details_of_each_wine
      @output_hash[:wine_details] = []

      @number_of_pages.times do |index|
        page_number = index + 1
        page_dom = dom_from_url(LaGrandeCave.base_url + "&page=#{page_number}")

        page_dom.search('.bouteille_liste').each do |wine_card_dom|
          wine_details = Wine::LaGrandeCave.build_from_dom(wine_card_dom).to_hash
          @logger.info(wine_details[:name])
          @output_hash[:wine_details] << wine_details
        end
      end
    end

    def run
      @dom = dom_from_url(LaGrandeCave.base_url)
      @website = "la_grande_cave"
      @number_of_pages = @dom.search('.pagination')[0].children[7].children.text.strip.to_i
      @output_hash[:wine_details] = []

      collect_details_of_each_wine

    rescue Interrupt, SignalException
      save_and_exit
    rescue => e
      @logger.fatal(e)
      Scraper::Base.null_value
    end
  end
end

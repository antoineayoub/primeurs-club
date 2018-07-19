module Scraper
  class LaGrandeCave < Base
    set_base_url "https://www.lagrandecave.fr/tousNosVins?format=1&tri=triAlphaAsc"
    set_output_file "la_grande_cave.json"

    # Due to the structure of the website, grouping wines together as vintages of a common wine
    # will have to be done after all wine information is collected.

    # This method collects all that information, but needs to be followed up with the
    # `condense_and_link_vintages` method
    def collect_uncondensed_wine_information
      @uncondensed_wines = []

      @number_of_pages.times do |index|
        page_number = index + 1
        page_dom = dom_from_url(LaGrandeCave.base_url + "&page=#{page_number}")

        page_dom.search('.bouteille_liste').each do |wine_card_dom|
          wine_details = Wine::LaGrandeCave::UncondensedWine.build_from_dom(wine_card_dom)
          @logger.info(wine_details.name)
          @uncondensed_wines << wine_details
        end
      end
    end

    # This method runs through the wine hash (in RAM) and reorders it, condensing wines into their
    # common wine prototype and nesting the remaining vintage specific information

    # Ultimately: fills the output hash that is used by the JSON generator
    def condense_and_link_vintages
      @logger.info("CONDENSING WINES AND LINKING VINTAGES")

      # See lib/scraper/wine/la_grande_cave/linker_condenser.rb for some documentations
      @output_hash[:wine_details] = Wine::LaGrandeCave::LinkerCondenser.run(@uncondensed_wines)
    end

    def run
      @dom = dom_from_url(LaGrandeCave.base_url)
      @website = "la_grande_cave"
      @number_of_pages = @dom.search('.pagination')[0].children[7].children.text.strip.to_i
      collect_uncondensed_wine_information
      condense_and_link_vintages

    rescue Interrupt, SignalException
      condense_and_link_vintages
      save_and_exit
    rescue => e
      @logger.fatal(e)
      Scraper::Base.null_value
    end
  end
end

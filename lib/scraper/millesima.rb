require 'selenium-webdriver'

module Scraper
  class Millesima < Base
    set_base_url "https://www.millesima.fr"
    set_output_file "millesima.json"

    def run
      millesima_index_page_scraper = Scraper::MillesimaIndexPage.run
      @wine_vintages = JSON.parse(File.open(millesima_index_page_scraper.output_file_path).read)["wine_vintages"]
      @website = "millesima"
      collect_details_of_each_wine
    end

    private

    def collect_details_of_each_wine
      @output_hash[:wine_details] = []

      @wine_vintages.keys.each { |wine_slug| collect_details_of_wine(wine_slug) }
    end

    def collect_details_of_wine(wine_slug)
      vintages = @wine_vintages[wine_slug]

      wine_hash = Wine::MillesimaWine.build_from_dom(dom_of_prototypal_wine(vintages)).to_hash
      wine_hash[:vintages] = vintages.map do |vintage|
        wine_vintage = Wine::MillesimaVintage.build_from_dom(dom_of_vintage(vintage))
        wine_vintage.price = vintage["price"]
        wine_vintage.to_hash
      end
      @output_hash[:wine_details] << wine_hash
    rescue Interrupt, SignalException
      save_and_exit
    rescue => e
      @logger.fatal(e)
      Scraper::Base.null_value
    end

    def dom_of_prototypal_wine(vintages)
      url = Millesima.base_url + "/#{vintages.first["slug"]}"
      @logger.info("PROTOTYPE WINE: visiting '#{url}'")
      dom_from_url(url)
    end

    def dom_of_vintage(vintage)
      url = Millesima.base_url + "/#{vintage["slug"]}"
      @logger.info("VINTAGE: visiting '#{url}'")
      dom_from_url(url)
    end
  end
end

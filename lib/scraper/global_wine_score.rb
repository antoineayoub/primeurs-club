module Scraper
  class GlobalWineScore < Base
    set_output_file "global_wine_score.json"

    def run
      cpt = 0
      gws_results = GWS.fetch_latest({ region: "Bordeaux" }).map do |wine_attributes|
        wine_attributes["name"] = wine_attributes.delete("wine")
        wine_attributes
        @logger.info(wine_attributes["name"])
        cpt += 1
      end
      @logger.info("Number of imported lines : #{cpt}")
      @output_hash = { wine_details: gws_results }
      rescue Interrupt, SignalException
        save_and_exit
      rescue => e
        @logger.fatal(e)
        Scraper::Base.null_value
    end
  end
end

module Scraper
  class GlobalWineScore < Base
    set_output_file "global_wine_score.json"

    def run
      gws_results = GWS.fetch_latest(region: "Bordeaux").map do |wine_attribues|
        wine_attribues["name"] = wine_attribues.delete("wine")
        wine_attribues
      end

      @output_hash = { wine_details: gws_results }
    end
  end
end

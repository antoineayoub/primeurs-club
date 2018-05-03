module Scraper
  class GlobalWineSurvey < Base
    set_output_file "gws.json"

    def run
      @output_hash = { wine_details: GWS.fetch_latest(region: "Bordeaux") }
    end
  end
end

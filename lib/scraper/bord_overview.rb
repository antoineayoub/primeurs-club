module Scraper
  class BordOverview < Base
    def run
      @output_hash[:wine_details] = collect_details_of_each_wine
    end
    
    private
    
    def collect_details_of_each_wine
    end
  end
end
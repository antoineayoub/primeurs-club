module Scraper
  class BordOverview < Base
    set_base_url "http://www.bordoverview.com/?year=all&bank=both"
    set_output_file "bord_overview.json"

    def self.headers
      [:name, :year, :appellation, :rating, :size, :by, :RP, :NM, :JR, :TA, :"B&D", :JS, :JL, :De, :RVF, :JA, :LeP, :PW, :RG, :price, :delta]
    end

    def run
      @dom = dom_from_url(BordOverview.base_url)
      @all_rows = @dom.search("#overview > tbody > tr")
      @output_hash[:wine_details] = collect_details_of_each_wine
    end
    
    private

    def collect_details_of_each_wine
      collect_unique_wine_names.map do |wine_name|
        begin
          wine_dom = dom_from_wine_name(wine_name)      
          wine = Wine::BordOverview.build_from_dom(wine_dom).to_hash
          @logger.info(wine[:name]) if wine[:name]
          wine
        rescue
          Scraper::Base.null_value
        end
      end
    end
    
    def dom_from_wine_name(wine_name)
      array_of_nodes = all_rows.select { |row| row.children.first.text.gsub(/\(buy\)$/, "").strip == wine_name }
      Nokogiri::XML::NodeSet.new(@dom, array_of_nodes)
    end

    def collect_unique_wine_names
      all_rows.map { |row| row.children.first.text.gsub(/\(buy\)$/, "") }.uniq
    end

    def all_rows
      @all_rows
    end
  end
end
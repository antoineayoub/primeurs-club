require 'open-uri'
require 'json'
require 'nokogiri'

module Scraper
  class BordeauxPrimeurs
    def self.base_url
      "http://www.bordeaux-primeurs.net"
    end

    def self.run
      new
    end

    def initialize
      @output_file_path = Rails.root.join("db/scraper/bordeaux_primeurs.json")
      @output_hash = {}
      @logger = Logger.new(STDOUT)
      @logger.progname = "scraper"

      @output_hash[:wine_slugs] = collect_all_wine_slugs
      @output_hash[:wine_details] = collect_details_of_each_wine
      write_to_output_file
    end
    
    private
    
    def collect_all_wine_slugs
      document_object_model = dom_from_url(BordeauxPrimeurs.base_url + "/vins-primeurs.php")
      links = document_object_model.search("a > font")
      links.map { |link| link.parent.attributes["href"].value.split(".").first }
    end

    def collect_details_of_each_wine
      @output_hash[:wine_slugs][1...5].map do |wine_slug|
         wine_details = collect_wine_details(wine_slug)
         @logger.info(wine_details)
         wine_details
      end
    end

    def collect_wine_details(wine_slug)
      document_object_model = dom_from_url(BordeauxPrimeurs.base_url + "/#{wine_slug}.php")
      Wine.build_from_dom(document_object_model).to_hash
    end

    def write_to_output_file
      stringified_json = JSON.pretty_generate(@output_hash)

      json_file = File.open(@output_file_path, "w")
      json_file.puts(stringified_json)
      json_file.close
    end

    def dom_from_url(url)
      Nokogiri::HTML(open(url), nil, 'utf-8')
    end
  end
end
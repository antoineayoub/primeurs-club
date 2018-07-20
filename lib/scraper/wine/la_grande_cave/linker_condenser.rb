# This is the JSON returned by Scraper::Wine::LaGrandeCave::LinkerCondenser::Condenser#to_hash

# {
#   "name": "Aile d'Argent 2008",
#   "type": "Caisse bois de 6 bouteilles (75cl)",
#   "pays": "France",
#   "region": "Bordeaux",
#   "appellation": "bordeaux blanc",
#   "classement": "2nd vin",
#   "superficie": "4 ha",
#   "age_moyen_des_vignes": null,
#   "vin_liquoreux": null,
#   "sols_et_sous_sols": null,
#   "image_url": null,
#   "elevage": null,
#   "vintages": [
#     {
#       "description": null,
#       "price": 6400,
#       "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#       "citation": null,
#       "year": "2017"
#     },
#     {
#       "description": null,
#       "price": 7600,
#       "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#       "citation": null,
#       "year": "2014"
#     },
#     {
#       "description": null,
#       "price": 7500,
#       "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#       "citation": null,
#       "year": "2011"
#     },
#     {
#       "description": null,
#       "price": 7500,
#       "encepagement": "sauvignon 57% - semillon 42% - muscadelle 1%",
#       "citation": null,
#       "year": "2009"
#     }
#   ]
# }

module Scraper
  module Wine
    module LaGrandeCave

      class LinkerCondenser
        def self.run(wines)
          Condenser.new(UrlLinks.new(wines)).to_hash
        end
        
        # This class takes in an instance of the UrlLinks class and preforms the condensing and 
        # formating. Since the UrlLinks is just a hash of urls, this find each wine object by its
        # url, extracts the wine info from the prototype wine, and adds an array of vintage
        # information extracted from each sibling wine (found by looking up using the sibling urls)
        class Condenser
          def initialize(url_links)
            # Array of Scraper::Wine::LaGrandeCave::UncondensedWine objects
            @wines = url_links.wines

            # Hash
            @url_links = url_links.url_links
          end

          def to_hash
            @url_links.map do |prototype_url, sibling_urls|
              format_wine_and_vintage_info(prototype_url, sibling_urls)
            end
          end
          
          private
          
          def format_wine_and_vintage_info(prototype_url, sibling_urls)
            prototype_wine = @wines.find { |wine| wine.page_url == prototype_url }
            output_hash = prototype_wine.wine_info
            output_hash[:vintages] = vintages_hash(sibling_urls)
            output_hash
          end

          def vintages_hash(sibling_urls)
            sibling_urls.map do |sibling_url|
              sibling_wine = @wines.find { |wine| wine.page_url == sibling_url }
              sibling_wine&.vintage_info
            end
          end
        end
        
        # This class represents the linking between a prototype wine url and it's siblings. Whether
        # a wine is a prototype of a sibling is arbitrary, the prototype just acts as a key and is
        # what will be used for the final wine info

        # UrlLinks#url_links returns a hash of prototype/sibling url links in to following format:
        # {
        #   "prototype_url" => ["sibling_url", "sibling_url", "sibling_url"],
        #   "prototype_url" => ["sibling_url", "sibling_url"],
        #   # ...
        # }
        class UrlLinks
          attr_reader :url_links, :wines

          def initialize(wines)
            @url_links = {}
            @wines = wines
            @wines.each { |wine| find_or_create_prototype_url(wine) }
          end
          
          private

          # If a wine's page_url is not already being used a sibling then a new prototype url is 
          # created and the sibling vintage urls stored in that wine are used as sibling urls 
          def find_or_create_prototype_url(wine)
            find_prototype_url(wine) || create_prototype_url(wine)
          end
          
          def find_prototype_url(wine)
            @url_links.keys.find do |prototype_url|
              @url_links[prototype_url].include?(wine.page_url)
            end
          end
          
          def create_prototype_url(wine)
            @url_links[wine.page_url] = wine.sibling_vintage_urls
            wine.page_url
          end
        end
      end
    end
  end
end

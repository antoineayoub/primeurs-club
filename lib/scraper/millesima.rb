require 'selenium-webdriver'

module Scraper
  class Millesima < Base
    set_base_url "https://www.millesima.fr"
    set_output_file "millesima.json"    

    def run
      @output_hash[:wine_vintages] = collect_wine_vintages
      @output_hash[:wine_details] = collect_details_of_each_wine
    end
    
    private
    
    def all_wine_slugs
      document_object_model = dom_from_url(Rails.root.join("db/html/millesima.html"))
      links = document_object_model.search(".product_name > a")
      links.map { |link| link.attributes["href"].value.split("/").last.split(".").first }.sort
    end
    
    def collect_details_of_each_wine
      @output_hash[:wine_vintages].keys.map do |wine_name|
        vintages = @output_hash[:wine_vintages][wine_name]
        {
          wine: Wine::MillesimaWine.build_from_dom(dom_of_prototypal_wine(vintages)).to_hash,
          vintages: vintages.map { |vintage| Wine::MillesimaVintage.build_from_dom(dom_of_vintage(vintage)).to_hash }
        }
      end
    end

    def collect_wine_vintages
      all_wine_slugs.each_with_object({}) do |slug, wine_vintages|
        wine_name = wine_name_from_slug(slug)
        
        if (wine_vintages.keys.include?(wine_name))
          wine_vintages[wine_name] << slug
        else
          wine_vintages[wine_name] = [slug]
        end
      end
    end
    
    def wine_name_from_slug(slug)
      slug.match(/^[a-zA-Z\-]*[a-zA-Z]/)[0]
    end

    def dom_of_prototypal_wine(vintages)
      url = Millesima.base_url + "/#{vintages.first}"
      @logger.info("visiting '#{url}''")
      dom_from_url(url)
    end
    
    def dom_of_vintage(vintage)
      url = Millesima.base_url + "/#{vintage}"
      @logger.info("visiting '#{url}'")

      options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
      driver = Selenium::WebDriver.for(:chrome, options: options)
      driver.get(url)

      html = driver.find_element(css: "html").attribute("outerHTML")
      driver.quit

      Nokogiri::HTML(html, nil, 'utf-8')
    end
  end
end

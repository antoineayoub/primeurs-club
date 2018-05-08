module Scraper
  class MillesimaIndexPage < Base
    set_base_url "https://www.millesima.fr"
    set_output_file "millesima_index_page.json"

    def self.total_number_of_wines
      2008
    end

    def self.page_size
      50
    end

    def self.start_page
      0
    end

    def run
      @output_hash[:wine_vintages] = collect_wine_vintages
    end

    def collect_wine_vintages
      all_wine_slugs_and_prices.each_with_object({}) do |vintage, wine_vintages|
        wine_name = wine_name_from_slug(vintage[:slug])

        if (wine_vintages.keys.include?(wine_name))
          wine_vintages[wine_name] << { slug: vintage[:slug], price: vintage[:price] }
        else
          wine_vintages[wine_name] = [{ slug: vintage[:slug], price: vintage[:price] }]
        end
      end
    end

    def all_wine_slugs_and_prices
      output = []

      each_page_of_fifty_wines do |dom|
        begin
          links = dom.search(".product_name > a")
          spans = dom.search(".content_price")

          validate_and_log(links, spans)

          links.zip(spans).each do |elements|
            begin
              slug = elements[0].attributes["href"].value.split("/").last.split(".").first
              price = (elements[1].search(".unitprice").first.text.match(/\((?<price>\d+,\d+)\s/)[:price].gsub(",", "").to_i rescue Scraper::Base.null_value)
              output << { slug: slug, price: price }
            rescue => e
              @logger.fatal(e)
            end
          end
        rescue => e
          @logger.fatal(e)
        end
      end

      output
    end

    def each_page_of_fifty_wines(&block)
      total_number_of_pages = Scraper::MillesimaIndexPage.total_number_of_wines / Scraper::MillesimaIndexPage.page_size
      (total_number_of_pages - Scraper::MillesimaIndexPage.start_page).times do |page_number|
        begin
          @logger.info("page number: #{page_number + Scraper::MillesimaIndexPage.start_page}")

          url = build_index_page_url(
            (page_number + Scraper::MillesimaIndexPage.start_page) * Scraper::MillesimaIndexPage.page_size,
            Scraper::MillesimaIndexPage.page_size
          )

          @logger.info("visiting: '#{url}'")

          driver = Selenium::WebDriver.for(:chrome, options: Selenium::WebDriver::Chrome::Options.new(args: ['headless']))
          driver.get(url)
          @logger.info("waiting for javascript to load")

          Selenium::WebDriver::Wait.new(timeout: 10).until do
            driver.find_element(css: "#progress_bar").css_value("display") == "none"
          end

          html = driver.find_element(css: "html").attribute("outerHTML")
          driver.quit
          dom = Nokogiri::HTML(html, nil, 'utf-8')

          yield(dom)
        rescue => e
          byebug
          @logger.fatal(e)
        end
      end
    end

    def wine_name_from_slug(slug)
      slug.match(/^[a-zA-Z\-]*[a-zA-Z]/)[0]
    end

    def build_index_page_url(start_index, size)
      "https://www.millesima.fr/bordeaux.html?#facet:1500666111117116101105108108101324055539910841&productBeginIndex:#{start_index}&facetLimit:&orderBy:6&pageView:list&minPrice:&maxPrice:&pageSize:#{size}&"
    end

    def validate_and_log(links, spans)
      @logger.info("current number of hits: #{links.count}")

      if links.count != spans.count
        raise Scraper::ScraperError, "Discordance between number of links:#{links.count} and number of spans:#{spans.count}"
      end
    end
  end
end

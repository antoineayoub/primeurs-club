module Seed
  class BordOverview
    def self.run(number_of_wines)
      new(number_of_wines)
    end

    def initialize(number_of_wines)
      @json = load_json
      @number_of_vendor_critics_created = 0
      @number_of_vendor_vintages_created = 0
      build_array_of_wine_details(number_of_wines)
      run
      Seed::Logger.info("number of vender critics created: #{@number_of_vendor_critics_created}")
      Seed::Logger.info("number of vender vintages created: #{@number_of_vendor_vintages_created}")
    end

    private

    def build_array_of_wine_details(number_of_wines)
      @wine_details = number_of_wines ? @json[:wine_details].sample(number_of_wines.to_i) : @json[:wine_details]
      Seed::Logger.info("number of wines being seeded #{@wine_details.length}")
    end

    def run
      @wine_details.each do |wine_attributes|
        begin
          appellation = Appellation.find_or_create_by(name: wine_attributes[:appellation])
          wine = build_wine_with_appellation(appellation, wine_attributes)
          build_vendor_vintages_for_wine(wine, wine_attributes)
          log_wine_information(wine)
        rescue => e
          Seed::Logger.error(e)
        end
      end
    end

    def load_json
      file_path = Dir.glob("#{Rails.root}/db/scraper/*_bord_overview.json").sort do |a, b|
        timestamp_of_file(a) <=> timestamp_of_file(b)
      end.first

      Seed::Logger.info("initializing seed with: '#{file_path}'")

      JSON.parse(File.open(file_path).read, symbolize_names: true)
    end

    def build_wine_with_appellation(appellation_object, wine_attributes)
      attributes = {
        website: website_name,
        name: wine_attributes[:name],
        rating: wine_attributes[:rating],
        appellation: appellation_object
      }

      VendorWine.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      Seed::Logger.warn(e)
    end

    def build_vendor_vintages_for_wine(wine_object, wine_attributes)
      wine_attributes[:vintages].each do |vintage_attributes|
        begin
          vintage = VendorVintage.create!(
            website: website_name,
            vintage: vintage_attributes[:year],
            price_cents: format_vintage_price(vintage_attributes[:price]),
            vendor_wine: wine_object
          )

          @number_of_vendor_vintages_created += 1

          Seed::Logger.debug(vintage.as_json)
          build_vendor_critics_for_vintage(vintage, vintage_attributes)
        rescue ActiveRecord::RecordInvalid => e
          Seed::Logger.warn(e)
        end
      end
    end

    def build_vendor_critics_for_vintage(vintage_object, vintage_attributes)
      raters = [:RP, :NM, :JR, :TA, :"B&D", :JS, :JL, :De, :RVF, :JA, :LeP, :PW, :RG]
      raters.each do |rater|
        begin
          wine_note = VendorCritic.create!(
            website: website_name,
            name: rater.to_s,
            note: vintage_attributes[rater],
            vendor_vintage: vintage_object
          )

          @number_of_vendor_critics_created += 1

          Seed::Logger.debug(wine_note.as_json)
        rescue ActiveRecord::RecordInvalid => e
          Seed::Logger.warn(e)
        end
      end
    end

    def website_name
      "bord overview"
    end

    def log_wine_information(wine_object)
      Seed::Logger.debug("wine created: #{wine_object.as_json}")
      Seed::Logger.debug("#{wine_object.vendor_vintages.map(&:vendor_critics).flatten.count} vendor_critics added")
      Seed::Logger.debug("#{wine_object.vendor_vintages.count} vendor_vintages added")
    end

    def timestamp_of_file(file_name)
      file_name.split("/").last.split("_").first.to_i
    end

    def format_vintage_price(price)
      price.is_a?(String) ? price.gsub(/\D/, "") : nil
    end
  end
end

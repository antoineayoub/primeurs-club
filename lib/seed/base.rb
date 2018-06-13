module Seed
  class Base
    def self.run(options = {})
      new(options)
    end

    def initialize(options)
      config_from_options(options)
      build_json_file_path
      load_json
      build_array_of_wine_details
      db_tally = Seed::DataBaseTally.begin_tracking(Seed::Logger)
      run
      db_tally.print_changes
    end

    private

    def shorter_name(gws_name)
      wine_name = gws_name.split(',')

      if wine_name.count <= 2
        wine_name = wine_name.first
      else
        wine_name = wine_name.first + wine_name.second
      end
      wine_name
    end

    def run
      @wine_details.each do |wine_attributes|
        begin
          appellation = Appellation.find_or_create_by(name: wine_attributes[:appellation])
          Seed::Logger.info("building wine: \"#{wine_attributes[:name]}\"")
          wine = build_wine_with_appellation(appellation, wine_attributes)
          build_vendor_vintages_for_wine(wine, wine_attributes)
        rescue => e
          Seed::Logger.error(e)
        end
      end
    end

    def config_from_options(options)
      @photo_upload = options[:photo_upload] || true
      @number_of_wines = options[:number_of_wines] || false
      @json_file_path = options[:json_file_path] || false
    end

    def photo_upload?
      @photo_upload
    end

    def build_json_file_path
      @file_path = if @json_file_path
        @json_file_path
      else
        JsonName.where(website: website_name).last.json.url unless JsonName.where(website: website_name).last.nil?
      end
    end

    def load_json
      Seed::Logger.info("initializing seed with: '#{@file_path}'")
      @json = JSON.load(open(@file_path))
      @json = JSON.parse(@json.to_json, symbolize_names: true)
    end

    def build_array_of_wine_details
      @wine_details = @number_of_wines ? @json[:wine_details][0...@number_of_wines.to_i] : @json[:wine_details]
      Seed::Logger.info("number of wines being seeded #{@wine_details.length}")
    end

    def timestamp_of_file(file_name)
      file_name.split("/").last.split("_").first.to_i
    end
  end
end

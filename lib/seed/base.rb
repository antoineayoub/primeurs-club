module Seed
  class Base
    def self.run(number_of_wines)
      new(number_of_wines)
    end

    def initialize(number_of_wines)
      @json = load_json
      build_array_of_wine_details(number_of_wines)
      run
    end

    private

    def load_json
      file_path = Dir.glob("#{Rails.root}/db/scraper/*_bordeaux_primeurs.json").sort do |a, b|
        timestamp_of_file(b) <=> timestamp_of_file(a)
      end.first

      Seed::Logger.info("initializing seed with: '#{file_path}'")
      JSON.parse(File.open(file_path).read, symbolize_names: true)
    end
  end
end
module Seed
  class Base
    def self.run(number_of_wines)
      new(number_of_wines)
    end

    def initialize(number_of_wines)
      @json = load_json
      build_array_of_wine_details(number_of_wines)
      db_tally = Seed::DataBaseTally.begin_tracking(Seed::Logger)
      run
      db_tally.print_changes
    end

    private

    def load_json
      file_path = Dir.glob("#{Rails.root}/db/scraper/*_#{website_name}.json").sort do |a, b|
        timestamp_of_file(b) <=> timestamp_of_file(a)
      end.first

      Seed::Logger.info("initializing seed with: '#{file_path}'")
      JSON.parse(File.open(file_path).read, symbolize_names: true)
    end

    def build_array_of_wine_details(number_of_wines)
      # @wine_details = number_of_wines ? @json[:wine_details].sample(number_of_wines.to_i) : @json[:wine_details]
      @wine_details = number_of_wines ? @json[:wine_details][0...number_of_wines.to_i] : @json[:wine_details]
      Seed::Logger.info("number of wines being seeded #{@wine_details.length}")
    end
  end
end

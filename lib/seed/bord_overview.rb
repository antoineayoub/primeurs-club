module Seed
  class BordOverview
    def self.run(number_of_wines)
      new(number_of_wines)
    end

    def initialize(number_of_wines)
      @json = load_json
      build_array_of_wine_details(number_of_wines)
      run
    end

    private

    def build_array_of_wine_details(number_of_wines)
      @wine_details = if number_of_wines
                        @json[:wine_details].sample(number_of_wines)
                      else
                        @json[:wine_details]
                      end

      Seed::Logger.info("number of wines being seeded #{number_of_wines}")
    end

    def run
      @wine_details.each do |wine_attributes|
        begin
          appellation = Appellation.find_or_create_by(name: wine_attributes[:appellation])

          wine = Wine.create!(
            name: wine_attributes[:name],
            rating: wine_attributes[:rating],
            appellation: appellation
          )

          wine_attributes[:vintages].each do |vintage_attributes|
            vintage = Vintage.create!(
              vintage: vintage_attributes[:year],
              price: format_vintage_price(vintage_attributes[:year]),
              wine: wine
            )

            Seed::Logger.debug(vintage.as_json)

            build_wine_notes_for_vintage(vintage, vintage_attributes)
          end

          Seed::Logger.info("wine created: #{wine.as_json}")
          Seed::Logger.info("#{wine.vintages.map(&:wine_notes).count} wine notes added -- #{WineNote.count} total")
          Seed::Logger.info("#{wine.vintages.count} vintages added -- #{Vintage.count} total")
        rescue => e
          Seed::Logger.error(e)
        end
      end
    end

    def load_json
      JSON.parse(File.open(Rails.root.join("db/scraper/bord_overview.json")).read, symbolize_names: true)
    end

    def build_wine_notes_for_vintage(vintage_object, vintage_attributes)
      raters = [:RP, :NM, :JR, :TA, :"B&D", :JS, :JL, :De, :RVF, :JA, :LeP, :PW, :RG]

      raters.each do |rater|
        wine_note = WineNote.create!(
          name: rater.to_s,
          note: vintage_attributes[rater],
          vintage: vintage_object
        )

        Seed::Logger.debug(wine_note.as_json)
      end
    end

    def format_vintage_price(price)
      price.is_a?(String) ? price.gsub(/\D/, "") : nil
    end
  end
end

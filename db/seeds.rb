require "json"
require "byebug"

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

Seed::Logger.info("destorying users")
User.destroy_all
Seed::Logger.info("destorying regions")
Region.destroy_all
Seed::Logger.info("destorying retailers")
Retailer.destroy_all
Seed::Logger.info("destorying wine notes")
WineNote.destroy_all
Seed::Logger.info("destorying vintages")
Vintage.destroy_all
Seed::Logger.info("destorying wines")
Wine.destroy_all

User.create!(email: "antoine@ppc.com", password: "12345678", admin: true)
Region.create(name: "Bordeaux")
# Retailer.create(name: "Château Primeur", category: "revendeur")
# Retailer.create(name: "Millesima", category: "revendeur")
# Retailer.create(name: "The Wine Merchang", category: "negociant")

bordeaux_primeurs_json = JSON.parse(File.open(Rails.root.join("db/scraper/bord_overview.json")).read, symbolize_names: true)

bordeaux_primeurs_json[:wine_details].each do |wine_attributes|
  begin
    appellation = Appellation.find_or_create_by(name: wine_attributes[:appellation])
    
    wine = Wine.create!(
      name: wine_attributes[:name],
      rating: wine_attributes[:rating],
      appellation: appellation
    )

    Seed::Logger.info(wine.as_json)

    wine_attributes[:vintages].each do |vintage_attributes|
      vintage = Vintage.create!(
        vintage: vintage_attributes[:year],
        price: format_vintage_price(vintage_attributes[:year]),
        wine: wine
      )

      Seed::Logger.debug(vintage.as_json)

      build_wine_notes_for_vintage(vintage, vintage_attributes)
    end

  rescue => e
    Seed::Logger.error(e)
  end
end

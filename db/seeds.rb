require "json"
require "byebug"

User.destroy_all
Region.destroy_all
Retailer.destroy_all

User.create!(email: "antoine@ppc.com", password: "12345678", admin: true)

Region.create(name: "Bordeaux")
  # Retailer.create(name: "Château Primeur", category: "revendeur")
  # Retailer.create(name: "Millesima", category: "revendeur")
  # Retailer.create(name: "The Wine Merchang", category: "negociant")

# bordeaux_primeurs_json = JSON.parse(File.open(Rails.root.join("db/scraper/bordeaux_primeurs.json")).read, symbolize_names: true)

# bordeaux_primeurs_json[:wine_details].each do |wine_attributes|
# end

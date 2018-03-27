User.destroy_all
Region.destroy_all
Retailer.destroy_all

User.create!(email: "antoine@ppc.com", password: "12345678", admin: true)

Region.create(name: "Bordeaux")
Retailer.create(name: "Château Primeur", category: "revendeur")
Retailer.create(name: "Millesima", category: "revendeur")
Retailer.create(name: "The Wine Merchang", category: "negociant")

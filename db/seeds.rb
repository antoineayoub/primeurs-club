# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: "antoine@ppc.com", password: "12345678", admin: true)

Region.create(name: "Bordeaux")
Retailer.create(name: "Château Primeur", type: "revendeur")
Retailer.create(name: "Millesima", type: "revendeur")
Retailer.create(name: "The Wine Merchang", type: "negociant")

# coding: utf-8
require 'pp'
require 'set'

def shorter_name(gws_name)
  wine_name = gws_name.split(',')

  if wine_name.count <= 2
    wine_name = wine_name.first
  else
    wine_name = wine_name.first + wine_name.second
  end
  wine_name
end

@logger = Logger.new(STDOUT)
# Retailer.create(name: "Château Primeur", category: "revendeur")
# Retailer.create(name: "Millesima", category: "revendeur")
# Retailer.create(name: "The Wine Merchang", category: "negociant")


User.create(email: "antoine@ppc.com", password: "12345678", admin: true)

regions = ["Bordeaux"]
wines = Set.new([]) # content can't be redundant

# Create regions
puts "Creating Regions..."
regions = regions.map { |region| [region, Region.find_or_create_by!(name: region)] }

puts "Creating Appelations..."
regions.each do |region_name, region_record|
  # API Call
  wines_data = GWS.fetch_latest({ region: region_name })
  wines_data.each do |wine|
    # Creates appelation
    appelation = region_record.appellations.find_or_create_by!(name: wine["appellation"])

    # Create a hash for each wine and store it in the `wines` array
    # Then we will group all wines by names and create them along their vintages
    wines << {
      wine: {
        appellation_id: appelation.id,
        name: shorter_name(wine["wine"]),
        rating: wine["classification"] ?  wine["classification"].gsub(/ en \d{2-4}/,"") : "",
        colour: wine["color"],
        wine_type: wine["wine_type"]
      },
      gws_data: wine
    }
  end
end

puts "Creating Wines & Vintages..."
# Create wines and vintages
wines_by_name = wines.group_by { |w| w[:wine][:name] }
# wines_by_name.each { |name, grp| p "#{name}: #{grp.count}" }

wines_by_name.each do |name, wines|

  wines.each do |wine_data|
    begin
    wine_record = wine_data[:wine]
    gws_data    = wine_data[:gws_data]

    wine = VendorWine.find_or_create_by!(wine_record)

    wine.vendor_vintages.find_or_create_by!(
      vintage: gws_data["vintage"],
      global_wine_score: gws_data["score"],
      gws_id: gws_data["wine_id"],
      lwin: gws_data["lwin"],
      lwin_11: gws_data["lwin_11"],
      confidence_index: gws_data["confidence_index"],
      website: "GWS"
    )

    rescue => e
      @logger.fatal(e)
    end
  end
end

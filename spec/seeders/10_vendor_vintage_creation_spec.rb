require "rails_helper"

def create_or_find_appellation
  Appellation.first || Appellation.create(name: "Bordeaux")
end

describe "VendorVintage#create_or_update_price" do
  let(:create_vendor_wine) {
    VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      country: "france",
      appellation: create_or_find_appellation,
      rating: "2e_cru_classe",
      website: "millesima",
      colour: "rouge"
    })
  }

  it "create a Vintage and VendorVintage if no other Vintage exists" do
    vendor_wine = VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      country: "france",
      appellation: create_or_find_appellation,
      rating: "2e_cru_classe",
      website: "millesima",
      colour: "rouge"
    })
    
    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2014",
      price_cents: 6208,
      vendor_wine: vendor_wine
    })

    expect(VendorVintage.count).to eq(1)
    expect(Vintage.count).to eq(1)
    expect(VendorWine.count).to eq(1)
    expect(Wine.count).to eq(1)
  end
  
  it "create a Vintage and VendorVintage if no Vintage matches the year" do
    vendor_wine = VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      country: "france",
      appellation: create_or_find_appellation,
      rating: "2e_cru_classe",
      website: "millesima",
      colour: "rouge"
    })
    
    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2014",
      price_cents: 6208,
      vendor_wine: vendor_wine
    })
    
    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2012",
      price_cents: 6208,
      vendor_wine: vendor_wine
    })

    expect(VendorVintage.count).to eq(2)
    expect(Vintage.count).to eq(2)
    expect(VendorWine.count).to eq(1)
    expect(Wine.count).to eq(1)
  end

  it "create a Vintage and VendorVintage if no Vintage matches the wine" do
    vendor_wine_one = VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      appellation: create_or_find_appellation,
      website: "millesima",
    })

    vendor_wine_two = VendorWine.create_and_match_with_wine({
      name: "Château Maucaillou",
      appellation: create_or_find_appellation,
      website: "millesima",
    })    
    
    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2014",
      vendor_wine: vendor_wine_one
    })

    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2014",
      vendor_wine: vendor_wine_two
    })    

    expect(VendorVintage.count).to eq(2)
    expect(Vintage.count).to eq(2)
    expect(VendorWine.count).to eq(2)
    expect(Wine.count).to eq(2)
  end

  it "not create a new Vintage if a match is found" do
    millesima_vendor_wine = VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      appellation: create_or_find_appellation,
      website: "millesima",
    })

    tastet_lawton_vendor_wine = VendorWine.create_and_match_with_wine({
      name: "Château Gruaud Larose",
      appellation: create_or_find_appellation,
      website: "tastet_lawton",
    })
    
    VendorVintage.create_or_update_price({
      website: "millesima",
      vintage: "2014",
      vendor_wine: millesima_vendor_wine
    })

    VendorVintage.create_or_update_price({
      website: "tastet_lawton",
      vintage: "2014",
      vendor_wine: tastet_lawton_vendor_wine
    })

    expect(VendorWine.count).to eq(2)
    expect(Wine.count).to eq(1)
    expect(VendorVintage.count).to eq(2)
    expect(Vintage.count).to eq(1)
  end
end

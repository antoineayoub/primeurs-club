require "rails_helper"

def create_or_find_appellation
  Appellation.first || Appellation.create(name: "Bordeaux")
end

describe "Wine/VendorWine Syncronization" do
  before(:each) { Seed::Clean.run }

  let(:valid_wine_attributes) {
    {
      name: "Château Gruaud Larose",
      country: "france",
      appellation: create_or_find_appellation,
      rating: "2e_cru_classe",
      colour: "rouge"
    }
  }

  context "creating a VendorWine" do
    it "create and link to a Wine if no match is found" do
      vendor_wine = VendorWine.create_and_match_with_wine(valid_wine_attributes)

      expect(Wine.count).to eq(1)
      expect(Wine.first.name).to eq("Château Gruaud Larose")
      expect(vendor_wine.wine).to eq(Wine.first)
    end

    it "not create, but link to a Wine a match is found" do
      Wine.create(valid_wine_attributes)

      vendor_wine = VendorWine.create_and_match_with_wine(valid_wine_attributes)

      expect(Wine.count).to eq(1)
      expect(Wine.first.name).to eq("Château Gruaud Larose")
      expect(vendor_wine.wine).to eq(Wine.first)
    end

    it "matches by slug rather than name" do
      Wine.create(valid_wine_attributes)

      valid_wine_attributes[:name] = "GRUAUD LAROSE"
      vendor_wine = VendorWine.create_and_match_with_wine(valid_wine_attributes)

      expect(vendor_wine.wine).to eq(Wine.first)
    end
  end
end

require "rails_helper"

def create_or_find_appellation
  Appellation.first || Appellation.create(name: "Bordeaux")
end

describe "Wine/VendorWine Syncronization" do
  after(:all) { Seed::Clean.run }

  describe "creating a VendorWine with direct method call" do
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

  describe "running two seeders" do
    before(:all) do
      Seed::Clean.run
      Seed::Millesima.run(json_file_path: Rails.root.join("spec", "seeders", "json", "wine_vendor_wine_sync_millesima_content.json"))
      Seed::Tastet.run(json_file_path: Rails.root.join("spec", "seeders", "json", "wine_vendor_wine_sync_tastet_lawton_content.json"))
    end

    it "creates VendorWines despite duplicates" do
      expect(VendorWine.count).to eq(4)
    end

    it "avoids duplicating Wines" do
      expect(Wine.count).to eq(3)
    end

    it "links VendorWines to Wines" do
      larose = Wine.find_by_slug("gruaud-larose")
      fourvieille = Wine.find_by_slug("guibot-la-fourvieille")
      maucaillou = Wine.find_by_slug("maucaillou")

      expect(larose.vendor_wines.count).to eq(2)
      expect(fourvieille.vendor_wines.count).to eq(1)
      expect(maucaillou.vendor_wines.count).to eq(1)
    end
  end
end

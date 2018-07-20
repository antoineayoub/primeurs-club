require "rails_helper"

describe Seed::LaGrandeCave do
  let(:website_name) { "la_grande_cave" }

  before(:all) do
    Seed::Clean.run
    Seed::LaGrandeCave.run(json_file_path: Rails.root.join("spec", "seeders", "json", "la_grande_cave_content.json"))
  end

  after(:all) { Seed::Clean.run }

  describe "Data Storage", type: :seeder do
    context Wine do
      it "stores correct number of Wines" do
        expect(Wine.count).to eq(2)
      end

      it "stores the correct name" do
        array_attribute_compare(Wine, :name, ["\"Y\" d'Yquem 2005", "Aile d'Argent 2008"])
      end

      it "stores the correct rating" do
        array_attribute_compare(Wine, :rating, ["2nd vin", "2nd vin"])
      end

      it "stores the correct country" do
        array_attribute_compare(Wine, :country, ["France", "France"])
      end

      # No colour data present?

      # it "stores the correct color" do
      #   array_attribute_compare(Wine, :colour, [])
      # end
    end

    context VendorWine do
      it "stores correct number of VendorWines" do
        expect(VendorWine.count).to eq(2)
      end

      it "stores the correct name" do
        array_attribute_compare(Wine, :name, ["\"Y\" d'Yquem 2005", "Aile d'Argent 2008"])
      end

      it "stores the correct website" do
        array_attribute_compare(VendorWine, :website, [website_name, website_name])
      end

      it "stores the correct Wine" do
        array_attribute_compare(VendorWine, :wine, [Wine.first, Wine.last])
      end
    end

    context VendorVintage do
      it "stores correct number of VendorVintages" do
        expect(VendorVintage.count).to eq(6)
      end

      it "stores the correct description" do
        array_attribute_compare(VendorVintage, :description,
          [nil] * 6)
      end

      it "stores the correct vintage" do
        array_attribute_compare(VendorVintage, :vintage, ["2014", "2012", "2017", "2014", "2011", "2009"])
      end

      it "stores the correct alcohol" do
        array_attribute_compare(VendorVintage, :alcohol, [nil] * 6)
      end

      it "stores the correct price_cents" do
        array_attribute_compare(VendorVintage, :price_cents, [13500, 13800, 6400, 7600, 6800, 7500])
      end

      it "stores the correct website" do
        array_attribute_compare(VendorVintage, :website, [website_name] * 6)
      end

      it "stores the correct vendor_wine" do
        array_attribute_compare(VendorVintage, :vendor_wine, [VendorWine.first] * 2 + [VendorWine.last] * 4)
      end
    end
  end
end


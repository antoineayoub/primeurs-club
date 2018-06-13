require "rails_helper"

describe "Slug Generation" do
  before(:each) { Seed::Clean.run }
  after(:all) { Seed::Clean.run }

  let(:simple_slugs) {
    {
      "Château Gruaud Larose" => "gruaud-larose",
      "Feytit-Clinet" => "feytit-clinet",
      "AIR DE VIEUX ROBIN" => "air-de-vieux-robin",
      "Château BRANE CANTENAC" => "brane-cantenac",
      "Blason d'Issan" => "blason-d-issan",
      "Château COS D'ESTOURNEL" => "cos-d-estournel"
    }
  }

  let(:advanced_slugs) {
    {
      "Blason d'Issan" => "blason-d-issan",
      "Chateau La Mission Haut Brion, Blanc, Pessac Leognan" => "la-mission-haut-brion",
      "Chateau Margaux, Margaux" => "margaux"
    }
  }

  it "generates proper slugs for Wines (simple)" do
    simple_slugs.each do |original_name, slug|
      wine = Wine.new(name: original_name)
      wine.save(validate: false)

      expect(wine.slug).to eq(slug)
    end
  end

  it "generates proper slugs for VendorWines (simple)" do
    skip
    simple_slugs.each do |original_name, slug|
      vendor_wine = VendorWine.new(name: original_name)
      vendor_wine.save(validate: false)

      expect(vendor_wine.slug).to eq(slug)
    end
  end

  it "generates proper slugs for Wines (advanced)" do
    skip
    advanced_slugs.each do |original_name, slug|
      wine = Wine.new(name: original_name)
      wine.save(validate: false)

      expect(wine.slug).to eq(slug)
    end
  end

  it "generates proper slugs for VendorWines (advanced)" do
    advanced_slugs.each do |original_name, slug|
      vendor_wine = VendorWine.new(name: original_name)
      vendor_wine.save(validate: false)

      expect(vendor_wine.slug).to eq(slug)
    end
  end
end

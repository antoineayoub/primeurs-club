require "rails_helper"

describe "Price updating" do
  before(:all) { 
    Seed::Clean.run 

    Seed::BordeauxPrimeurs.run(json_file_path: Rails.root.join("spec", "seeders", "json", "bordeau_primeurs_price_change_first.json"))

    @first_vendor_vintages = VendorVintage.all.to_a

    Seed::BordeauxPrimeurs.run(json_file_path: Rails.root.join("spec", "seeders", "json", "bordeau_primeurs_price_change_second.json"))

    @second_vendor_vintages = VendorVintage.all.to_a
  }

  after(:all) { Seed::Clean.run }

  it "does not create duplicate VendorVintages" do
    expect(@first_vendor_vintages.count).to eq(@second_vendor_vintages.count)
  end

  it "updates prices" do
    first_vendor_vintage = @first_vendor_vintages.find { |vendor_vintage| vendor_vintage.vintage == "2010" }
    second_vendor_vintage = @second_vendor_vintages.find { |vendor_vintage| vendor_vintage.vintage == "2010" }

    expect(first_vendor_vintage.price_cents).to eq(20_000)
    expect(second_vendor_vintage.price_cents).to eq(20_100)
  end
end

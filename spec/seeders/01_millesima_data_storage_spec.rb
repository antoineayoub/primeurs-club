require "rails_helper"

describe Seed::Millesima do
  let(:website_name) { "millesima" }

  before(:all) do
    Seed::Clean.run
    Seed::Millesima.run(json_file_path: Rails.root.join("spec", "seeders", "json", "millesima_content.json"))
  end

  after(:all) { Seed::Clean.run }

  describe "Data Storage", type: :seeder do
    context Wine do
      it "stores correct number of Wines" do
        expect(Wine.count).to eq(2)
      end

      it "stores the correct name" do
        array_attribute_compare(Wine, :name, ["Château Maucaillou", "Château Gruaud Larose"])
      end

      it "stores the correct rating" do
        array_attribute_compare(Wine, :rating, [nil, "2e_cru_classe"])
      end

      it "stores the correct country" do
        array_attribute_compare(Wine, :country, ["france", "france"])
      end

      it "stores the correct color" do
        array_attribute_compare(Wine, :colour, ["rouge", "rouge"])
      end
    end

    context VendorWine do
      it "stores correct number of VendorWines" do
        expect(VendorWine.count).to eq(2)
      end

      it "stores the correct name" do
        array_attribute_compare(VendorWine, :name, ["Château Maucaillou", "Château Gruaud Larose"])
      end

      it "stores the correct description" do
        array_attribute_compare(VendorWine, :description,
          [
            "Un Moulis 2014 Délicat Le château Maucaillou 2014 semble de prime abord timide dès les premières sensations olfactives. L'agitation révèle au contraire un vin moins masqué, plus aromatique sur un fruité noir mêlé d'une touche empyreumatique. En bouche, le vin a du poids et délivre des tanins riches, d'un caractère séveux sans agresser. Ce Moulis doit se fondre mais montre un potentiel de vieillissement. Très classique !",
            "Un vin rouge de Saint-Julien puissant et fin  La couleur du Château Gruaud-Larose 2012 est d'un noir intense et sombre. Le nez est puissant et dominé par une forte palette aromatique de fruits. L'attaque est agréable, la bouche est ronde avec de nombreuses saveurs, une grande souplesse, une certaine finesse et des tanins présents mais sans rusticité. L'ensemble de ce Saint-Julien 2012 est très beau et l'évolution en barrique prometteuse pour ce Château Gruaud-Larose 2012 qui, jouant l'authenticité aromatique, délectera les palais les plus exigeants."
          ]
        )
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
        expect(VendorVintage.count).to eq(8)
      end

      it "stores the correct description" do
        array_attribute_compare(VendorVintage, :description,
          ["Un Moulis 2014 Délicat Le château Maucaillou 2014 semble de prime abord timide dès les premières sensations olfactives. L'agitation révèle au contraire un vin moins masqué, plus aromatique sur un fruité noir mêlé d'une touche empyreumatique. En bouche, le vin a du poids et délivre des tanins riches, d'un caractère séveux sans agresser. Ce Moulis doit se fondre mais montre un potentiel de vieillissement. Très classique !"] * 4 +
          ["Un vin rouge de Saint-Julien puissant et fin  La couleur du Château Gruaud-Larose 2012 est d'un noir intense et sombre. Le nez est puissant et dominé par une forte palette aromatique de fruits. L'attaque est agréable, la bouche est ronde avec de nombreuses saveurs, une grande souplesse, une certaine finesse et des tanins présents mais sans rusticité. L'ensemble de ce Saint-Julien 2012 est très beau et l'évolution en barrique prometteuse pour ce Château Gruaud-Larose 2012 qui, jouant l'authenticité aromatique, délectera les palais les plus exigeants."] * 4
        )
      end

      it "stores the correct vintage" do
        array_attribute_compare(VendorVintage, :vintage, ["2014", "2016", "2017", "2010", "2012", "2014", "2017", "2016"])
      end

      it "stores the correct alcohol" do
        array_attribute_compare(VendorVintage, :alcohol, ["13"] * 4 + ["13.5"] * 4)
      end

      it "stores the correct price_cents" do
        array_attribute_compare(VendorVintage, :price_cents, [4500, 1900, nil, 2792, 6208, 6458, nil, 7000])
      end

      it "stores the correct website" do
        array_attribute_compare(VendorVintage, :website, [website_name] * 8)
      end

      it "stores the correct vendor_wine" do
        array_attribute_compare(VendorVintage, :vendor_wine, [VendorWine.first] * 4 + [VendorWine.last] * 4)
      end
    end

    context Critic do
      it "stores correct number of VendorCritics" do
        expect(Critic.count).to eq(40)
      end

      it "stores the correct name" do
        array_attribute_compare(
          Critic,
          :name,
          ["P", "JR", "WS", "RG"],
          first: 4
        )
      end

      it "stores the correct note" do
        array_attribute_compare(
          Critic,
          :note,
          ["91", "15", "87-90", "15"],
          first: 4
        )
      end
    end

    it "running the seeder multiple times creates no duplicates" do
      Seed::Millesima.run(json_file_path: Rails.root.join("spec", "seeders", "json", "millesima_content.json"))
      
      expect(Wine.count).to eq(2)
      expect(VendorWine.count).to eq(2)
      expect(VendorVintage.count).to eq(8)
      expect(Critic.count).to eq(40)
    end
  end
end

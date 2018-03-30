module Seed
  class Clean
    def self.run
      Seed::Logger.info("destorying all #{VendorCritic.count} vendor critics")
      VendorCritic.destroy_all
      Seed::Logger.info("destorying all #{VendorVintage.count} vendor vintages")
      VendorVintage.destroy_all
      Seed::Logger.info("destorying all #{VendorWine.count} vendor wines")
      VendorWine.destroy_all
      Seed::Logger.info("destorying all #{WineNote.count} wine notes")
      WineNote.destroy_all
      Seed::Logger.info("destorying all #{Vintage.count} vintages")
      Vintage.destroy_all
      Seed::Logger.info("destorying all #{Wine.count} wines")
      Wine.destroy_all
      Seed::Logger.info("destorying all #{Appellation.count} appellations")
      Appellation.destroy_all
      Seed::Logger.info("destorying all #{User.count} users")
      User.destroy_all
      Seed::Logger.info("destorying all #{Region.count} regions")
      Region.destroy_all
      Seed::Logger.info("destorying all #{Retailer.count} retailers")
      Retailer.destroy_all
    end
  end
end
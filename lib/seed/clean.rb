module Seed
  class Clean
    def self.run
      Seed::Logger.info("destorying all #{User.count} users")
      User.destroy_all
      Seed::Logger.info("destorying all #{Region.count} regions")
      Region.destroy_all
      Seed::Logger.info("destorying all #{Retailer.count} retailers")
      Retailer.destroy_all
      Seed::Logger.info("destorying all #{WineNote.count} wine notes")
      WineNote.destroy_all
      Seed::Logger.info("destorying all #{Vintage.count} vintages")
      Vintage.destroy_all
      Seed::Logger.info("destorying all #{Wine.count} wines")
      Wine.destroy_all
    end
  end
end
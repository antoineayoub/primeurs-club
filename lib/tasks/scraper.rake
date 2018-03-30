namespace :scraper do
  desc "chateau primeurs scraper"
  task chateau_primeurs: [:environment] do
    Scraper::ChateauPrimeurs.new.run
  end

  desc "millesima scraper"
  task millesima: [:environment] do
    Scraper::Millesima.run
  end

  desc "bordeaux primeurs scraper"
  task bordeaux_primeurs: [:environment] do
    Scraper::BordeauxPrimeurs.run
  end
  
  desc "bord overview scraper"
  task bord_overview: [:environment] do
    Scraper::BordOverview.run
  end

  desc "bord overview scraper"
  task millesima_index_page: [:environment] do
    Scraper::MillesimaIndexPage.run
  end
end

namespace :seed do
  desc "delete all records in the database"
  task clean: [:environment] do
    Seed::Clean.run
  end

  desc "bord overview seed"
  task :bord_overview, [:number_of_wines] => [:environment] do |task, args|
    Seed::BordOverview.run(args[:number_of_wines].to_i)
  end

  desc "bordeaux primeurs seed"
  task bordeaux_primeurs: [:environment] do
    Seed::BordeauxPrimeurs.run
  end
end

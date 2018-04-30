namespace :scraper do
  desc "chateau primeurs scraper"
  task chateau_primeurs: [:environment] do
    Scraper::ChateauPrimeurs.run
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

  desc "tastet csv converter"
  task tastet: [:environment] do
    Seed::Tastet.generate_json_file
  end
end

namespace :seed do
  desc "delete all records in the database"
  task clean: [:environment] do
    Rails.logger.silence { Seed::Clean.run }
  end

  desc "bord overview seed"
  task :bord_overview, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::BordOverview.run(args[:number_of_wines]) }
  end

  desc "bordeaux primeurs seed"
  task :bordeaux_primeurs, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::BordeauxPrimeurs.run(args[:number_of_wines]) }
  end

  desc "millesima seed"
  task :millesima, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::Millesima.run(args[:number_of_wines]) }
  end

  desc "tastet seed"
  task :tastet, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::Tastet.run(args[:number_of_wines]) }
  end  
end

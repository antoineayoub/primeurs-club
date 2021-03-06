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

  desc "global wine score"
  task gws: [:environment] do
    Scraper::GlobalWineScore.run
  end

  desc "la grande cave"
  task la_grande_cave: [:environment] do
    Scraper::LaGrandeCave.run
  end
end

namespace :seed do
  desc "delete all records in the database"
  task clean: [:environment] do
    Rails.logger.silence { Seed::Clean.run }
  end

  desc "bord overview seed"
  task :bord_overview, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::BordOverview.run(number_of_wines: args[:number_of_wines]) }
  end

  desc "bordeaux primeurs seed"
  task :bordeaux_primeurs, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::BordeauxPrimeurs.run(number_of_wines: args[:number_of_wines]) }
  end

  desc "millesima seed"
  task :millesima, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::Millesima.run(number_of_wines: args[:number_of_wines]) }
  end

  desc "tastet seed"
  task :tastet, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::Tastet.run(number_of_wines: args[:number_of_wines]) }
  end

  desc "chateau primeurs seed"
  task :chateau_primeurs, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::ChateauPrimeurs.run(number_of_wines: args[:number_of_wines]) }
  end

  desc "global wine score"
  task :gws, [:number_of_wines] => [:environment] do |_task, args|
    Rails.logger.silence { Seed::GlobalWineScore.run(number_of_wines: args[:number_of_wines]) }
  end
end

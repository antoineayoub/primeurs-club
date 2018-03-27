namespace :scraper do
  desc "chateau primeurs scraper"
  task :chateau_primeurs => [:environment] do
    Scraper::ChateauPrimeurs.new.run
  end

  desc "millesima scraper"
  task :millesima => [:environment] do
    Scraper::Millesima.new.run
  end 

  desc "bordeaux primeurs scraper"  
  task :bordeaux_primeurs => [:environment] do
    Scraper::BordeauxPrimeurs.run
  end

  desc "bord overview scraper"  
  task :bordeaux_primeurs => [:environment] do
    Scraper::BordOverview.run
  end  
end

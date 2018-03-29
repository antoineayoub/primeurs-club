namespace :scraper do
  desc "chateau primeurs scraper"
  task :chateau_primeurs => [:environment] do
    Scraper::ChateauPrimeurs.new.run
  end

  desc "millesima scraper"
  task :millesima => [:environment] do
    Scraper::Millesima.run
  end 

  desc "bordeaux primeurs scraper"  
  task :bordeaux_primeurs => [:environment] do
    Scraper::BordeauxPrimeurs.run
  end
  
  desc "bord overview scraper"  
  task :bord_overview => [:environment] do
    Scraper::BordOverview.run
  end

  desc "bord overview scraper"  
  task :millesima_index_page => [:environment] do
    Scraper::MillesimaIndexPage.run
  end  
end

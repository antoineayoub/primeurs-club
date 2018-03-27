require 'scraper/chateau_primeurs'

desc "Scraper"
task :scraper => [:environment] do

  puts "What would you like to scrap ?"
  puts "1- Château Primeurs"
  puts "2- Millesima"
  puts "3- Exit"
  result = STDIN.gets.chomp.to_i

  if result == 1
    scraper_chateau_primeurs
  elsif result == 2
    scraper_millesima
  else
    exit
  end
end

def scraper_chateau_primeurs
  Scraper::ChateauPrimeurs.new.run
end

def scraper_millesima
  Scraper::Millesima.new.run
end

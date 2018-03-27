require 'open-uri'
require 'net/http'
require 'nokogiri'

module Scraper
  class Millesima
    def run
      begin
        html_file = open("https://www.chateauprimeur.com/Grand-vins-Bordeaux-primeur-2016")
        html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')
        nb_pages = html_doc.search('.pagination > .tc span').last.text.to_i

        region = Region.create(name: "Bordeaux")
        puts nb_pages
        for i in (1..nb_pages)
          puts "Page n°#{i}"
          url = "https://www.chateauprimeur.com/catalogue/tous/2016?url=Grand-vins-Bordeaux-primeur-2016&page=#{i}"
          html_file = open(url)
          html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')
          wine_cards =  html_doc.search('.produit')

          wine_cards.each do |wine_card|
            show_url = wine_card.search('a').attribute('href').value
            wine_url   = "https://www.chateauprimeur.com#{show_url}"

            #Appellation
            appellation = wine_card.search(".produit_appellation").text

            find_appellation = Appellation.find_by_name(appellation)
            unless find_appellation
              find_appellation = Appellation.create!(name: appellation, region_id: region.id)
            end

            #Wine
            puts wine_name = wine_card.search(".produit_description a strong").text.strip.gsub(/\s*2016/,"")
            rating = wine_card.search(".produit_classement").text.strip || ""

            status = wine_card.search(".produit_btn > a").text
            status = "Sorti" if status == "Je commande"

            wine = Wine.create(name: wine_name,appellation_id: find_appellation.id,rating: rating)

            #vintage
            public_price = (wine_card.search(".prix").text.strip.gsub(/\s€\s*/,"").to_f*100).to_i

            vintage = Vintage.create!(vintage: 2016, wine_id: wine.id, public_price: public_price, status: status)

            wine_details  = Nokogiri::HTML(open(wine_url), nil, 'utf-8')

            wine_details.search(".produit_notations li").each do |note|
              vintage.update!(description:  wine_details.search(".description").text  )
              note_tbl = note.text.strip.split(/\s:\s/)
              WineNote.create(name: note_tbl[0],note: note_tbl[1],vintage_id: vintage.id)
            end
          end
        end
      rescue NoMethodError => e
        return 1
      end
    end
  end
end

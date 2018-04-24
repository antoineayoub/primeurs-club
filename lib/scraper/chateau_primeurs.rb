require 'open-uri'
require 'net/http'
require 'nokogiri'
require "active_support/inflector" # not necessary if Rails


module Scraper
  class ChateauPrimeurs < Base

    set_base_url "https://www.chateauprimeur.com/Grand-vins-Bordeaux-primeur-2017/"
    set_output_file "chateau_primeur.json"

    def run
      @dom = dom_from_url(ChateauPrimeurs.base_url)
      @nb_pages = @dom.search('.pagination > .tc span').last.text.to_i

      begin
          html_file = open("https://www.chateauprimeur.com/Grand-vins-Bordeaux-primeur-2017/")
          html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')

          puts @nb_pages
          for i in (1..@nb_pages)
            puts "Page n°#{i}"
            url = "https://www.chateauprimeur.com/catalogue/tous/2017?url=Grand-vins-Bordeaux-primeur-2017&page=#{i}"
            html_file = open(url)
            html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')
            wine_cards =  html_doc.search('.produit')

            wine_cards.each do |wine_card|
              show_url = wine_card.search('a').attribute('href').value
              wine_url   = "https://www.chateauprimeur.com#{show_url}"

              #Appellation
              puts region = "Bordeaux"
              puts appellation = wine_card.search(".produit_appellation").text.strip

              #Wine
              puts wine_name = wine_card.search(".produit_description a strong").text.strip.gsub(/\s*2017/,"")
              puts wine_slug = slugify(wine_name)
              puts rating = wine_card.search(".produit_classement").text.strip || ""

              status = wine_card.search(".produit_btn > a").text.strip
              puts status = "launched" if status == "Je commande"
              puts status = "coming" if status == "A venir"
              puts status = "out_of_stock" if status == "Epuisé"
              puts status = "not_sale" if status == "Non mis en marché"

              puts price = (wine_card.search(".prix").text.strip.gsub(/\s€\s*/,"").to_f*100).to_i

              wine_details  = Nokogiri::HTML(open(wine_url), nil, 'utf-8')
              puts delivery_date = wine_details.search(".produit_livraison").text.strip
              puts description = wine_details.search(".description").text.strip

              wine_details.search(".ligne_poste").each do |ligne|
                puts bottlinge = ligne.children.search('.format_cond').text.strip
                puts price = ligne.children.search('.format_quan').children.search('select').first.attributes["price"].value.to_f
                puts extra_charge = ligne.children.search('.format_supp > span').text.strip
              end

              wine_details.search(".produit_notations li").each do |critic|
                critic_tbl = critic.text.strip.split(/\s:\s/)
                puts wine_critic_name = critic_tbl[0].strip
                puts wine_note = critic_tbl[1].strip
              end

              wine_details.search(".produit").each do |product|
               puts other_wine = slugify(product.search("img").first.attributes["alt"].value.strip.gsub(/\s*2017/,""))
              end

            end
          end
        rescue NoMethodError => e
          puts e
          return 1
      end
    end


    def slugify(wine_name)
      ActiveSupport::Inflector.transliterate(wine_name).downcase.gsub!(/[^0-9A-Za-z]/, '_')
    end
  end
end

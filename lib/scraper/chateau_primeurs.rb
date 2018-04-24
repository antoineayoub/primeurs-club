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
      @output_hash[:wine_details] = []

      begin
          html_file = open("https://www.chateauprimeur.com/Grand-vins-Bordeaux-primeur-2017/")
          html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')

          puts @nb_pages
          for i in (1..@nb_pages)
            wine = {}

            puts "Page n°#{i}"
            url = "https://www.chateauprimeur.com/catalogue/tous/2017?url=Grand-vins-Bordeaux-primeur-2017&page=#{i}"
            html_file = open(url)
            html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')
            wine_cards =  html_doc.search('.produit')

            wine_cards.each do |wine_card|
              show_url = wine_card.search('a').attribute('href').value
              wine_url   = "https://www.chateauprimeur.com#{show_url}"

              #Appellation
              puts wine[:region] = "Bordeaux"
              wine[:appellation] = wine_card.search(".produit_appellation").text.strip

              #Wine
              wine[:wine_name] = wine_card.search(".produit_description a strong").text.strip.gsub(/\s*2017/,"")
              @logger.info(wine[:wine_name]) if wine[:wine_name]

              wine[:wine_slug] = slugify(wine[:wine_name])
              wine[:rating] = wine_card.search(".produit_classement").text.strip || ""

              status = wine_card.search(".produit_btn > a").text.strip
              wine[:status] = "launched" if status == "Je commande"
              wine[:status] = "coming" if status == "A venir"
              wine[:status] = "out_of_stock" if status == "Epuisé"
              wine[:status] = "not_sale" if status == "Non mis en marché"

              wine[:price] = (wine_card.search(".prix").text.strip.gsub(/\s€\s*/,"").to_f*100).to_i

              wine_details  = Nokogiri::HTML(open(wine_url), nil, 'utf-8')
              wine[:delivery_date] = wine_details.search(".produit_livraison").text.strip
              wine[:description] = wine_details.search(".description").text.strip

              wine[:bottling] = []

              wine_details.search(".ligne_poste").each do |ligne|
                bottling = {}
                bottling[:bottling] = ligne.children.search('.format_cond').text.strip
                bottling[:price] = ligne.children.search('.format_quan').children.search('select').first.attributes["price"].value.to_f
                bottling[:extra_charge] = ligne.children.search('.format_supp > span').text.strip
                wine[:bottling] << bottling
              end

              wine[:wine_critic] = []

              wine_details.search(".produit_notations li").each do |critic|
                wine_critic = {}
                critic_tbl = critic.text.strip.split(/\s:\s/)
                wine_critic[:wine_critic_name] = critic_tbl[0].strip
                wine_critic[:wine_note] = critic_tbl[1].strip

                wine[:wine_critic] << wine_critic
              end

              wine[:other_wine] = []
              wine_details.search(".produit").each do |product|
                other_wine = {}
                other_wine[:wine_slug] = slugify(product.search("img").first.attributes["alt"].value.strip.gsub(/\s*2017/,""))
                wine[:other_wine] << other_wine
              end

              puts wine
              @output_hash[:wine_details] << wine
            end
          end
        rescue Interrupt, SignalException
          save_and_exit
        rescue => e
          @logger.fatal(e)
          Scraper::Base.null_value
      end
    end


    def slugify(wine_name)
      ActiveSupport::Inflector.transliterate(wine_name).downcase.gsub!(/[^0-9A-Za-z]/, '_')
    end
  end
end

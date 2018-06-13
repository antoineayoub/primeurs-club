module Scraper
  class LaGrandeCave < Base
    set_base_url "https://www.lagrandecave.fr/tousNosVins?format=1"
    set_output_file "la_grande_cave.json"

    def run
      @dom = dom_from_url(LaGrandeCave.base_url)
      @website = "la_grande_cave"
      @nb_pages = @dom.search('.pagination')[0].children[7].children.text.strip.to_i
      @output_hash[:wine_details] = []

      begin
        puts @nb_pages
        for i in (1..@nb_pages)
          wine = {}

          puts "Page n°#{i}"
          html_doc  = dom_from_url(LaGrandeCave.base_url + "&page=#{i}")

          wine_cards =  html_doc.search('.bouteille_liste')

          wine_cards.each do |wine_card|
            wine_url = wine_card.search('.infos > a').attribute('href').value

            html_doc  = dom_from_url(wine_url)

            build_details_hash(html_doc, "details")
            wine[:pays] = "France"
            wine[:region] = "Bordeaux"
            wine[:name] = wine_card.search(".nom_vin > h2 .up").text.strip
            wine[:type] = wine_card.search(".contenance_vin").text.strip
            wine[:appellation] = @details_hash[:appellation]
            wine[:classement] = @details_hash[:classement]
            wine[:superficie] = @details_hash[:superficie]
            wine[:encepagement] = @details_hash[:encepagement]
            wine[:age_moyen_des_vignes] = @details_hash[:age_moyen_des_vignes]
            wine[:elevage] = @details_hash[:elevage]
            wine[:label_url] = wine_card.search('img[role="visuel_principal"]')[0].src

            vintages = []

            if wine_type == 'Primeur'
              wine[:price] = wine_card.search(".prix_vin").text.strip.gsub(/\s€\s*/,"").to_f*100).to_i
            else
              wine[:price] = wine_card.search(".prix_unite > strong").text.strip.gsub(/\s€\s*/,"").to_f*100).to_i
            end

            build_details_hash(html_doc, "notations")
            wine[:destription] = wine_card.search('#millesimes').first.text.strip

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
    private

    def build_details_hash(dom, id)
      words = dom.search("##{id} tr").map do |tr|
        [tr.children[1].text.strip.downcase.gsub(/(é|è)/, "e").gsub(/\s/, "_"),
        tr.children[3].text.strip.downcase]
      end

      @details_hash = words.to_h.symbolize_keys
    end
  end
end

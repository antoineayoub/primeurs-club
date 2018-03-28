require 'open-uri'
require 'json'
require 'nokogiri'

module Scraper
  module BaseClassMethods
    def run
      scraper = new
      scraper.write_to_output_file
    end
  
    def set_base_url(base_url)
      @@base_url = base_url
    end
  
    def set_output_file(output_file_name)
      @@output_file_name = output_file_name
    end    

    def output_file_name
      @@output_file_name
    end
  
    def base_url
      @@base_url
    end
  
    def null_value
      nil
    end
  end

  class Base
    extend BaseClassMethods

    def initialize
      @output_file_path = Rails.root.join("db/scraper/#{self.class.output_file_name}")

      @logger = Logger.new(STDOUT)
      @output_hash = {}

      run
    end    

    def write_to_output_file
      stringified_json = JSON.pretty_generate(@output_hash)

      json_file = File.open(@output_file_path, "w")
      json_file.puts(stringified_json)
      json_file.close
    end

    private

    def dom_from_url(url)
      Nokogiri::HTML(open(url), nil, 'utf-8')
    end    
  end
end
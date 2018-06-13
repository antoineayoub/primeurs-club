require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'

module Scraper
  class ScraperError < StandardError; end

  module BaseClassMethods
    attr_reader :base_url, :output_file_name

    def run
      scraper = new
      scraper.run
    ensure
      scraper.write_to_output_file
      scraper
    end

    def set_base_url(base_url)
      @base_url = base_url
    end

    def set_output_file(output_file_name)
      @output_file_name = output_file_name
    end

    def null_value
      nil
    end
  end

  class Base
    extend BaseClassMethods

    attr_reader :output_file_path

    def initialize
      puts @output_file_path = Rails.root.join("db/scraper/#{DateTime.now.strftime('%Y%m%d%H%M%S')}_#{self.class.output_file_name}")

      @logger = Logger.new(STDOUT)
      @output_hash = {}
    end

    def write_to_output_file
      stringified_json = JSON.pretty_generate(@output_hash)
    ensure
      json_file = File.open(@output_file_path, "w")
      json_file.puts(stringified_json)
      
      json_name = JsonName.new(name: name_from_path(@output_file_path), website: @website )
      json_name.json = json_file
      json_name.save
      
      json_file.close

      Seed::Logger.info("file uploaded: #{json_name.json_url}")
    end

    private

    def dom_from_url(url)
      Nokogiri::HTML(open(url), nil, 'utf-8')
    end

    def name_from_path(path)
      File.basename(path,".*")
    end

    def save_and_exit
      @logger.fatal("MANUAL INTERRUPT. WRITING TO OUTPUT FILE.")
      write_to_output_file
      @logger.fatal("EXITING.")
      exit
    end
  end
end

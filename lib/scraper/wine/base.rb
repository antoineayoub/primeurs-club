require "active_support/inflector" # not necessary if Rails

module Scraper
  module Wine
    module BaseClassMethods
      attr_accessor :before_scraping_methods, :attributes

      def null_value
        nil
      end

      def build_from_dom(dom)
        new(dom)
      end

      def set_attributes(*attributes)
        @attributes = attributes
      end

      def before_scraping(*methods)
        @before_scraping_methods = methods
      end

      def slugify(wine_name)
        ActiveSupport::Inflector.transliterate(wine_name).strip.downcase.gsub(/[^0-9A-Za-z]/, '-')
      end
    end

    class Base
      extend BaseClassMethods

      def initialize(dom)
        @attributes = self.class.attributes
        @dom = dom
        run_before_scraping_methods
        collect_all_attributes
      end

      def to_hash
        @attributes.each_with_object({}) do |attribute, hash|
          hash[attribute] = instance_variable_get("@#{attribute}")
        end
      end

      private

      def dom
        @dom
      end

      def dom_from_url(url)
        Nokogiri::HTML(open(url), nil, 'utf-8')
      end

      def run_before_scraping_methods
        if self.class.before_scraping_methods
          self.class.before_scraping_methods.each { |method_symbol| send(method_symbol) }
        end
      end

      def collect_all_attributes
        @attributes.each do |attribute|
          begin
            instance_variable_set("@#{attribute.to_s}", send(attribute))
          rescue NoMethodError
            instance_variable_set("@#{attribute.to_s}", Scraper::Base.null_value)
          end
        end
      end
    end
  end
end

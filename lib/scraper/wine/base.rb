module Scraper
  module Wine
    module BaseClassMethods
      def null_value
        nil
      end
  
      def build_from_dom(dom)
        new(dom)
      end
  
      def wine_attributes(*attributes)
        @@attributes = attributes
      end
    end

    class Base
      extend BaseClassMethods

      def initialize(dom)
        @attributes = self.class.attributes
        @dom = dom
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
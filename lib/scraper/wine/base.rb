module Scraper
  module Wine
    module BaseClassMethods
      def null_value
        nil
      end
  
      def build_from_data(data)
        new(data)
      end
  
      def set_attributes(*attributes)
        @@attributes = attributes
      end

      def attributes
        @@attributes
      end
    end

    class Base
      extend BaseClassMethods

      def initialize(data)
        @attributes = self.class.attributes
        @data = data
        collect_all_attributes
      end

      def to_hash
        @attributes.each_with_object({}) do |attribute, hash|
          hash[attribute] = instance_variable_get("@#{attribute}")
        end
      end

      private

      def data
        @data
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
module Standardization
  module Slug
    module SlugClassMethods
      def create_slug_from_name(*methods)
        @slug_methods = methods
        before_validation { |record| record.create_slug }
      end

      def slugify(string)
        @slug_methods.each do |method|
           string = send(method, string)
        end
  
        string
      end
  
      def all_lowercase(string)
        string.downcase
      end
  
      def remove_special_characters(string)
        # This may cause issues if the I18n locale is set externally 
        I18n.transliterate(string)
      end
  
      def remove_the_word_chateau(string)
        string.gsub(/\Achateau\s?/, "")
      end
  
      def convert_spaces_to_hyphens(string)
        string.gsub(/\s/, "-")
      end    
    end

    def self.included(base)
      base.extend(SlugClassMethods)
    end

    def create_slug
      self.slug = self.class.slugify(name)
    end
  end
end
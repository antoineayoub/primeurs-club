module WineModules
  module StandardizeName
    private

    STANDARD_SLUG_METHODS = [
      :clip_by_commas,
      :remove_space_around,
      :all_lowercase,
      :remove_special_characters,
      :remove_double_space,
      :remove_the_word_chateau,
      :convert_spaces_to_hyphens
    ]

    def standardize_name
      return false unless name

      self.slug = Slug.generate(name, STANDARD_SLUG_METHODS)
    end

    class Slug
      attr_reader :string

      def self.generate(string, slug_methods)
        new(string, slug_methods).string
      end

      def initialize(string, slug_methods)
        @string = string
        slug_methods.each { |method| send(method) } if @string
      end

      def remove_space_around
        @string = @string.strip
      end

      def all_lowercase
        @string = @string.downcase
      end

      def remove_special_characters
        # This may cause issues if the I18n locale is set externally
        @string = I18n.transliterate(@string).gsub(/[^0-9A-Za-z]/, ' ')
      end

      def remove_double_space
        # This may cause issues if the I18n locale is set externally
        @string = @string.gsub(/ +/, ' ')
      end

      def remove_the_word_chateau
        @string = @string.gsub(/\Achateau\s?/, "")
      end

      def convert_spaces_to_hyphens
        @string = @string.gsub(/\s/, "-")
      end

      def clip_by_commas
        @string = @string.split(',')

        if @string.count <= 2
          @string = @string.first
        else
          @string = @string.first + @string.second
        end
      end
    end
  end
end

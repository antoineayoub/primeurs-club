module WineModules
  module StandardizeName
    private

    def standardize_name
      self.slug = name

      return false unless name

      remove_space_around
      all_lowercase
      remove_special_characters
      remove_double_space
      remove_the_word_chateau
      convert_spaces_to_hyphens
    end

    def remove_space_around
      self.slug = slug.strip
    end

    def all_lowercase
      self.slug = slug.downcase
    end

    def remove_special_characters
      # This may cause issues if the I18n locale is set externally
      self.slug = I18n.transliterate(slug).gsub(/[^0-9A-Za-z]/, ' ')
    end

    def remove_double_space
      # This may cause issues if the I18n locale is set externally
      self.slug = slug.gsub(/ +/, ' ')
    end

    def remove_the_word_chateau
      self.slug = slug.gsub(/\Achateau\s?/, "")
    end

    def convert_spaces_to_hyphens
      self.slug = slug.gsub(/\s/, "-")
    end
  end
end

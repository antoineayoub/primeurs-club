module WineModules
  module StandardizeName
    private

    def standardize_name
      self.slug = name

      return false unless name

      all_lowercase
      remove_special_characters
      remove_the_word_chateau
      convert_spaces_to_hyphens
    end

    def all_lowercase
      self.slug = slug.downcase
    end

    def remove_special_characters
      # This may cause issues if the I18n locale is set externally 
      self.slug = I18n.transliterate(slug)
    end

    def remove_the_word_chateau
      self.slug = slug.gsub(/\Achateau\s?/, "")
    end

    def convert_spaces_to_hyphens
      self.slug = slug.gsub(/\s/, "-")
    end
  end
end

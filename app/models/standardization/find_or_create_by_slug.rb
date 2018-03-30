module Standardization
  module FindOrCreateBySlug
    module FindOrCreateBySlugClassMethods
      def find_or_create_by_slug(name, &block)
        slug = slugify(name)

        result = find_by_slug(slug)

        if result
          result
        else
          new_record = new(name: name)
          block.call(new_record)
          new_record.save
          new_record
        end
      end
    end

    def self.included(base)
      base.extend(FindOrCreateBySlugClassMethods)
    end
  end
end
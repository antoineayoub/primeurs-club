module WineModules
  module FindOrCreateByWithLogging
    def find_or_create_by(attrs, &block)
      find_or_create_by_with_logging(attrs, &block)
    end

    private

    def find_or_create_by_with_logging(attrs, &block)
      if record = find_by(attrs)
        seed_log_duplicate
      else
        record = create(attrs, &block)
      end

      record
    end
  end
end
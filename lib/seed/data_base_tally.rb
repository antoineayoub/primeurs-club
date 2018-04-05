module Seed
  class DataBaseTally
    def self.begin_tracking(logger)
      new(logger)
    end

    def print_changes
      @initial_tally.sort_by { |_k, v| -(v.abs) }.each do |table_name, initial_record_count|
        log_change(table_name, initial_record_count)
      end
      @initial_tally.sort_by { |_k, v| -(v.abs) }.each do |table_name, initial_record_count|
        log_total(table_name, initial_record_count)
      end      
    end

    private

    def log_change(table_name, initial_record_count)
      class_name = ActiveSupport::Inflector.classify(table_name)
      current_record_count = ActiveSupport::Inflector.constantize(class_name).count
      delta = current_record_count - initial_record_count

      if delta > 0
        @logger.info("#{table_name.pluralize} created: #{delta}")
      elsif delta < 0
        @logger.info("#{table_name.pluralize} destroyed: #{delta.abs}")
      end

    end
    
    def log_total(table_name, initial_record_count)
      @logger.info("#{table_name.pluralize} total: #{current_record_count}")
    end

    def initialize(logger)
      @logger = logger
      @initial_tally = {}

      all_table_names_in_db.each do |table_name|
        class_name = ActiveSupport::Inflector.classify(table_name)
        @initial_tally[table_name] = ActiveSupport::Inflector.constantize(class_name).count
      end
    end

    def all_table_names_in_db
      ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]
    end
  end
end

module Seed
  class Clean
    def self.run
      db_tally = Seed::DataBaseTally.begin_tracking(Seed::Logger)

      table_names = [
        "images",
        "critics",
        "vintages",
        "vendor_critics",
        "vendor_vintages",
        "vendor_wines",
        "wines",
        "appellations",
        "regions",
        "retailers",
        "users"
      ]

      table_names.each do |table_name|
        # class_name = ActiveSupport::Inflector.classify(table_name)
        # humanized_table_name = ActiveSupport::Inflector.humanize(table_name).pluralize
        # model = ActiveSupport::Inflector.constantize(class_name)
        # Seed::Logger.info("destroying #{model.count} #{humanized_table_name}")
        # model.destroy_all
        ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
      end

      db_tally.print_changes
    end
  end
end

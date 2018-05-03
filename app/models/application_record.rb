class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.create_unless_duplicate(attrs, logger = nil)
    record = find_by(attrs) || new(attrs)

    if record.persisted?
      seed_log_duplicate
    elsif record.save
      logger&.debug("#{record.class} #{record.as_json}")
    else
      logger&.warn("#{record.class} is invalid: #{record.errors.messages}")
    end

    record
  end

  def self.seed_log_duplicate
    Seed::Logger&.info("#{self}: Duplicate")
  end

  def log_results_of_save
    if persisted?
      Seed::Logger&.debug("#{self.class}: #{self.as_json}")
    else
      Seed::Logger&.warn("#{self.class} is invalid: #{self.errors.messages}")
    end
  end    
end

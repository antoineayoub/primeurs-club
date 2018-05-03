class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.seed_log_duplicate
    Seed::Logger&.info("#{self}: Duplicate")
  end

  private

  def log_results_of_save
    if persisted?
      Seed::Logger&.debug("#{self.class}: #{self.as_json}")
    else
      Seed::Logger&.warn("#{self.class} is invalid: #{self.errors.messages}")
    end
  end    
end

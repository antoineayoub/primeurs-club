class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # As of now this method only conditionally creates
  # I don't yet know what the update conditions should be
  def self.conditionally_create(attrs, logger = nil)
    record = find_by(attrs) || new(attrs)

    if record.persisted?
      logger&.debug("Duplicate object detected")
    elsif record.save
      logger&.debug("#{record.class} #{record.as_json}")
    else
      logger&.warn("#{record.class} is invalid: #{record.errors.messages}")
    end

    record
  end
end

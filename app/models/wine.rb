class Wine < ApplicationRecord
  include WineModules::StandardizeName

  belongs_to :appellation

  has_many :photos, as: :imageable
  has_many :vintages
  has_many :photos

  before_validation :standardize_name

  validates_uniqueness_of :slug
end

class Wine < ApplicationRecord
  include WineModules::StandardizeName

  belongs_to :appellation

  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vintages, dependent: :destroy

  before_validation :standardize_name

  validates_uniqueness_of :slug
end

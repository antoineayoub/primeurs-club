class Wine < ApplicationRecord
  include WineModules::StandardizeName
  include WineModules::Photo

  belongs_to :appellation

  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vintages, dependent: :destroy
  has_many :vendor_wines
  has_many :vendor_vintages, through: :vendor_wines

  before_validation :standardize_name

  validates_uniqueness_of :slug

  def self.find_by_slug_or_create(attrs)
    find_by(slug: attrs[:slug]) || create!(attrs.except(:description, :website))
  end
end

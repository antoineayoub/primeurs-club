class Wine < ApplicationRecord
  include WineModules::StandardizeName
  include WineModules::Photo

  has_many :images, as: :imageable, dependent: :destroy

  belongs_to :appellation

  has_many :vintages, dependent: :destroy
  has_many :vendor_wines
  has_many :vendor_vintages, through: :vendor_wines

  before_create :standardize_name

  validates_uniqueness_of :slug



  def self.find_by_slug_or_create(attrs)
    find_by(slug: attrs[:slug]) || create!(attrs.except(:description, :website))
  end
end

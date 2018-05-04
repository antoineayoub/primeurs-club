class VendorWine < ApplicationRecord
  include WineModules::Photo
  include WineModules::StandardizeName

  belongs_to :region, optional: true
  belongs_to :wine
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vendor_vintages, dependent: :destroy

  validates :name, presence: true

  before_create :standardize_name

  after_save :log_results_of_save

  def self.find_by_slug_or_create(attrs)
    attrs[:wine] = Wine.find_by_slug_or_create(attrs)

    found_vendor_wine = find_by(slug: attrs[:slug], website: attrs[:website])

    if found_vendor_wine
      seed_log_duplicate
      found_vendor_wine
    else
      create!(attrs.slice(:name, :slug, :description, :wine, :website))
    end
  end
end

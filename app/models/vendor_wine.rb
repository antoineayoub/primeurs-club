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
    attrs[:slug] = Slug.generate(attrs[:name], WineModules::StandardizeName::STANDARD_SLUG_METHODS)

    if found_vendor_wine = find_by(slug: attrs[:slug], website: attrs[:website])
      seed_log_duplicate
      found_vendor_wine
    else
      create_and_match_with_wine(attrs)
    end
  end

  def self.create_and_match_with_wine(wine_attrs)
    wine_attrs[:slug] = Slug.generate(wine_attrs[:name], WineModules::StandardizeName::STANDARD_SLUG_METHODS)

    wine = Wine.find_by_slug_or_create(wine_attrs)

    vendor_wine = new(wine_attrs.slice(:name, :description, :website))
    vendor_wine.wine = wine
    vendor_wine.save!
    vendor_wine
  end
end

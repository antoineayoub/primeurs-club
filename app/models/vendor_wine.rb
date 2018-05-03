class VendorWine < ApplicationRecord
  include WineModules::Photo
  include WineModules::StandardizeName

  belongs_to :region, optional: true
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vendor_vintages, dependent: :destroy

  validates :name, presence: true

  after_save :log_results_of_save

  def self.find_by_slug_or_create(attrs)
    attrs[:slug] = Slug.generate(attrs[:name], WineModules::StandardizeName::STANDARD_SLUG_METHODS)
    attrs[:wine] = Wine.find_by_slug_or_create(attrs)

    found_vendor_wine = find_by(slug: attrs[:slug]) 

    if found_vendor_wine
      seed_log_duplicate
      found_vendor_wine
    else
      create!(attrs.slice(:name, :slug, :description))
    end
  end
end

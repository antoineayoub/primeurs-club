class VendorVintage < ApplicationRecord
  class VendorVintageError < StandardError; end

  module VendorVintageClassMethods
    def create_or_update_price(attrs)
      existing_vendor_vintage = find_by_wine_and_year(attrs)

      if existing_vendor_vintage.nil?
        # This is a new vintage from this vendor that we haven't seen before
        # If we cannot find it's canonical Vintage, create a new one

        Vintage.find_by(wine: attrs[:vendor_wine].wine, vintage: attrs[:vintage]) || 
          Vintage.create!(attrs.slice(*Vintage.attribute_names.map(&:to_sym)).merge({wine: attrs[:vendor_wine].wine}))

        # Create and return a new VendorVintage
        return self.create!(attrs)

      elsif existing_vendor_vintage.price_has_changed_from(attrs[:price_cents])
        # Otherwise, if the price has changed since the last time we've seen it, update it's price
        Seed::Logger&.info("Updating #{existing_vendor_vintage.info_description} price from #{existing_vendor_vintage.price_cents} to #{attrs[:price_cents]}")
        existing_vendor_vintage.update!(price_cents: attrs[:price_cents])
      else
        seed_log_duplicate
      end

      existing_vendor_vintage
    end

    private

    def find_by_wine_and_year(vendor_vintage_attrs)
      unless [:vendor_wine, :vintage].all? { |attribute| vendor_vintage_attrs.include?(attribute) }
        raise VendorVintageError, "Must include vendor_wine and vintage on vendor_vintage creation"
      end

      find_by(vendor_vintage_attrs.slice(:vendor_wine, :vintage, :website))
    end
  end

  include WineModules::StandardizeName
  extend VendorVintageClassMethods

  belongs_to :vendor_wine
  has_many :critics, dependent: :destroy

  validates_presence_of :vendor_wine

  after_save :log_results_of_save

  def price_has_changed_from(price_cents)
    price_cents && self.price_cents != price_cents
  end

  def info_description
    "#{vendor_wine.name} / #{vintage}"
  end

  def prototypical_vintage
    vendor_wine.wine.vintages.find_by_vintage(vintage)
  end
end

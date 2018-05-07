class VendorVintage < ApplicationRecord
  class VendorVintageError < StandardError; end

  module VendorVintageClassMethods
    def create_or_update_price(attrs)
      existing_vendor_vintage = find_by_wine_and_year(attrs)

      if existing_vendor_vintage && existing_vendor_vintage.price_has_changed_from(attrs[:price_cents])
        Seed::Logger&.info("Updating #{existing_vendor_vintage.info_description} price from #{existing_vendor_vintage.price_cents} to #{attrs[:price_cents]}")
        existing_vendor_vintage.update(price_cents: attrs[:price_cents])
      elsif existing_vendor_vintage.nil?
        return create(attrs)
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

      find_by(vendor_vintage_attrs.slice(:vendor_wine, :vintage))
    end
  end

  include WineModules::StandardizeName
  extend VendorVintageClassMethods

  belongs_to :vendor_wine
  has_many :vendor_critics, dependent: :destroy

  validates_presence_of :vendor_wine

  after_save :log_results_of_save

  def price_has_changed_from(price_cents)
    price_cents && self.price_cents != price_cents
  end

  def info_description
    "#{vendor_wine.name} / #{vintage}"
  end
end

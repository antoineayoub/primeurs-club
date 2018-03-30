class VendorWine < ApplicationRecord
  belongs_to :appellation
  belongs_to :region, optional: true
  has_many :vendor_vintages
end

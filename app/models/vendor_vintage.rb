class VendorVintage < ApplicationRecord
  belongs_to :vendor_wine
  has_many :vendor_critics, dependent: :destroy
end

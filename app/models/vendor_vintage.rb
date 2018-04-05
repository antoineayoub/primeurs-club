class VendorVintage < ApplicationRecord
  belongs_to :vendor_wine
  has_many :vendor_critics, dependent: :destroy

  validates_presence_of :vendor_wine
end

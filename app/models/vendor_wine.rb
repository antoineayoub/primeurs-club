class VendorWine < ApplicationRecord
  belongs_to :appellation
  belongs_to :region, optional: true
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vendor_vintages, dependent: :destroy

  validates :name, presence: true
end

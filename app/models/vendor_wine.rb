class VendorWine < ApplicationRecord
  include WineModules::Photo
  include WineModules::StandardizeName

  belongs_to :appellation
  belongs_to :region, optional: true
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :vendor_vintages, dependent: :destroy

  validates :name, presence: true

  before_save :standardize_name

end

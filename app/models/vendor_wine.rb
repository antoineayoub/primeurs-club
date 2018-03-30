class VendorWine < ApplicationRecord
  belongs_to :appellation
  belongs_to :region
end

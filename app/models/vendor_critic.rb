class VendorCritic < ApplicationRecord
  belongs_to :vendor_vintage

  validates_presence_of :vendor_vintage
end

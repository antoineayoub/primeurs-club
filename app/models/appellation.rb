class Appellation < ApplicationRecord
  has_many :wines, dependent: :destroy
  has_many :vendor_wines, dependent: :destroy
end

class Wine < ApplicationRecord
  belongs_to :appellation
  has_many :retailer_stocks
  has_many :vintages
end

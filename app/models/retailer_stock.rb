class RetailerStock < ApplicationRecord
  belongs_to :retailer
  belongs_to :vintage
end

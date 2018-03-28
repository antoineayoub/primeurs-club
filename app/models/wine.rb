class Wine < ApplicationRecord
  belongs_to :appellation
  has_many :vintages
  has_many :photos
end

class Wine < ApplicationRecord
  belongs_to :appellation
  has_many :vintages
end

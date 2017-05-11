class Region < ApplicationRecord
  has_many :appellations
  has_many :wines, through: :appellations
end

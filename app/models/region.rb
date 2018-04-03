class Region < ApplicationRecord
  has_many :appellations, dependent: :destroy
end

class Vintage < ApplicationRecord
  belongs_to :wine
  has_many :wine_note
  has_many :user_stocks
  has_many :retailer_stocks
  has_many :retailers, through: :retailer_stocks

end

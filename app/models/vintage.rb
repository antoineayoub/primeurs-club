class Vintage < ApplicationRecord
  belongs_to :wine
  has_many :wine_notes, dependent: :destroy

end

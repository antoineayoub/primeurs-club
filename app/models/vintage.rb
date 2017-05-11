class Vintage < ApplicationRecord
  belongs_to :wine
  belongs_to :wine_note
end

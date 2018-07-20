class Vintage < ApplicationRecord
  belongs_to :wine
  has_many :critics, dependent: :destroy

end

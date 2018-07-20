class Appellation < ApplicationRecord
  has_many :wines, dependent: :destroy
end

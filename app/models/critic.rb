class Critic < ApplicationRecord
  extend WineModules::FindOrCreateByWithLogging
  belongs_to :vintage
  validates_presence_of :vintage
end

class Wine < ApplicationRecord
  include Standardization::Slug
  include Standardization::FindOrCreateBySlug

  belongs_to :appellation
  has_many :vintages
  has_many :photos

  create_slug_from_name :all_lowercase, :remove_special_characters, :remove_the_word_chateau, :convert_spaces_to_hyphens
  validates_uniqueness_of :slug
end

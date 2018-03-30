class Appellation < ApplicationRecord
  include Standardization::Slug
  
  has_many :wines

  create_slug_from_name :all_lowercase, :remove_special_characters, :convert_spaces_to_hyphens
  validates_uniqueness_of :slug
end

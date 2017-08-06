class Word < ApplicationRecord
  belongs_to :unit
  validates :content, uniqueness: true
end

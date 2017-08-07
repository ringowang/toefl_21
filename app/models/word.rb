class Word < ApplicationRecord
  belongs_to :unit
  validates :content, uniqueness: true
  validates :content, presence: true
  validates :meaning, presence: true
  validates :weight, presence: true
end

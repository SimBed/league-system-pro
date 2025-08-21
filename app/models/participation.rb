class Participation < ApplicationRecord
  belongs_to :match
  belongs_to :participant, polymorphic: true
  scope :order_by_score, -> { order(score: :desc) }
  validates :score, numericality: { greater_than_or_equal_to: -9999.9, less_than_or_equal_to: 9999.9 }
end

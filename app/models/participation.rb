class Participation < ApplicationRecord
  belongs_to :match
  belongs_to :participatable, polymorphic: true
  scope :order_by_score, -> { order(score: :desc) }
end

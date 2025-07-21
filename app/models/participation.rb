class Participation < ApplicationRecord
  belongs_to :match
  belongs_to :participatable, polymorphic: true
  # accepts_nested_attributes_for :participatable
  scope :order_by_score, -> { order(score: :desc) }
end

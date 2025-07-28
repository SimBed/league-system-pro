class Match < ApplicationRecord
  belongs_to :league
  has_many :participations, dependent: :destroy
  has_many :players, through: :participations, source: :participatable, source_type: "Player"
  accepts_nested_attributes_for :participations
  validates :date, presence: true
  scope :order_by_date, -> { order(date: :desc) }

  def number
    league.matches.where("created_at < ?", self.created_at).count + 1
  end
end

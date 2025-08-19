class Match < ApplicationRecord
  belongs_to :league
  has_many :participations, dependent: :destroy
  has_many :players, through: :participations, source: :participatable, source_type: "Player"
  accepts_nested_attributes_for :participations
  validates :date, presence: true
  scope :order_by_date, -> { order(date: :desc, created_at: :desc) }

  def number
    if new_record?
      league.matches.size
    else
      earlier_date = league.matches.where("date < ?", self.date).size
      same_day_created_earlier = league.matches.where("date = ?", self.date).where("created_at < ?", self.created_at).size
      earlier_date + same_day_created_earlier + 1
    end
  end

  def top_participations
    max_score = participations.maximum(:score)
    participatables = participations.includes(:participatable).where(score: max_score).map { |p| p.participatable.full_name }
    { winner: participatables.join("/"),
      winning_score: max_score }
  end
end

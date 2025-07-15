class Player < ApplicationRecord
  belongs_to :team, optional: true
  has_many :participations, as: :participatable, dependent: :destroy
  has_many :matches, through: :participations

  def self.with_scores_for(league_id)
    select(
      "players.*,
      COUNT(p.id) AS matches_played,
      SUM(p.score) AS total_score,
      AVG(p.score) AS average_score"
    )
    .joins("INNER JOIN participations p ON p.participatable_id = players.id AND p.participatable_type = 'Player'")
    .joins("INNER JOIN matches ON matches.id = p.match_id")
    .where(matches: { league_id: league_id })
    .group(:id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

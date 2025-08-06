class Player < ApplicationRecord
  belongs_to :team, optional: true
  has_many :participations, as: :participatable, dependent: :destroy
  has_many :matches, through: :participations
  has_many :leagues, through: :matches

  def self.with_league_stats(league_id: nil)
    select(
      "players.*,
      matches.league_id,
      COUNT(p.id) AS matches_played,
      SUM(p.score) AS total_score,
      AVG(p.score) AS average_score"
    )
    .joins("INNER JOIN participations p ON p.participatable_id = players.id AND p.participatable_type = 'Player'")
    .joins("INNER JOIN matches ON matches.id = p.match_id")
    .group("players.id, matches.league_id")
    .then { |chain| league_id.present? ? chain.where(matches: { league_id: league_id }) : chain }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

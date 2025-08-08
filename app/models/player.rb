class Player < ApplicationRecord
  belongs_to :team, optional: true
  has_many :participations, as: :participatable, dependent: :destroy
  has_many :matches, through: :participations
  has_many :leagues, through: :matches

  def self.with_league_stats(league_id: nil)
    # https://ruby-doc.org/core-2.5.0/doc/syntax/literals_rdoc.html To call a method on a heredoc place it after the opening identifier:
    # COUNT(CASE WHEN p.score = max_scores.max_score THEN 1 END) AS wins
    with(
        # Step 1: Get max score per match
        max_scores: Participation
          .where(participatable_type: "Player")
          .select("match_id, MAX(score) AS max_score")
          .group(:match_id),

        # Step 2: Count how many players got that max score
        winners: Participation
          .joins("INNER JOIN max_scores ms ON ms.match_id = participations.match_id AND participations.score = ms.max_score")
          .where(participatable_type: "Player")
          .select("ms.match_id, ms.max_score, COUNT(*) AS num_winners")
          .group("ms.match_id, ms.max_score")
      )
      .select(<<~SQL)
        players.*,
        matches.league_id,
        COUNT(p.id) AS matches_played,
        SUM(p.score) AS total_score,
        AVG(p.score) AS average_score,
        SUM(
          CASE
            WHEN p.score = w.max_score
            THEN 1.0 / w.num_winners
            ELSE 0
          END
        ) AS wins
      SQL
      .joins("INNER JOIN participations p ON p.participatable_id = players.id AND p.participatable_type = 'Player'")
      .joins("INNER JOIN matches ON matches.id = p.match_id")
      .joins("INNER JOIN winners w ON w.match_id = p.match_id")
      .group("players.id, matches.league_id")
      .then { |chain| league_id.present? ? chain.where(matches: { league_id: league_id }) : chain }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

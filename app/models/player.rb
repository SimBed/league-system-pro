class Player < ApplicationRecord
  attr_accessor :creator # allows a check on name uniqueness (per admin) at time of creation.
  belongs_to :team, optional: true
  has_many :participations, as: :participatable, dependent: :destroy
  has_many :matches, through: :participations
  has_many :leagues, through: :matches
  has_many :player_auths, dependent: :destroy
  has_many :users, through: :player_auths
  before_validation :titleize_full_name
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validate :full_name_unique_for_admin
  scope :order_by_name, -> { order(:first_name, :last_name) }

  def self.with_league_stats(league_id: nil)
    # https://ruby-doc.org/core-2.5.0/doc/syntax/literals_rdoc.html To call a method on a heredoc place it after the opening identifier:
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

  def admin
    users.joins(:player_auths)
         .find_by(player_auths: { role: :admin })
  end

  private

  def titleize_full_name
  self.first_name = first_name.strip.titleize
  self.last_name = last_name.strip.titleize
  end

  def full_name_unique_for_admin
    return unless creator

    duplicates = creator.players.where([ "first_name = ? and last_name = ?", first_name, last_name ]).then { |chain| persisted? ? chain.where.not(id: id) : chain }
    error_message = "You already have a player named #{full_name}"
    if duplicates.exists?
      # want 1 error message but both fields hilighted  - used in conjunction with skipping an error message in the form's player.errors.any? loop
      errors.add(:first_name, error_message)
      errors.add(:last_name, "")
    end
  end
end

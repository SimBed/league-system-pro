class League < ApplicationRecord
  attr_accessor :creator # allows a check on name uniqueness (per admin) at time of creation. Note the creator will be set as the admin, though can potentially subsequently be changed. And creator is not permanently stored.
  has_many :matches, dependent: :destroy
  has_many :league_auths, dependent: :destroy
  has_many :users, through: :league_auths
  before_validation :titleize_full_name
  validates :name, presence: true, length: { maximum: 20 }
  validates :season, presence: true, length: { maximum: 20 }
  # validates :participants_per_match, presence: true
  validates :participant_type, presence: true
  validates :participants_per_match, numericality: { only_integer: true, in: (1..10) }
  validates :participant_type, inclusion: { in: %w[ player team ] }
  # validates :name, uniqueness: { scope: :season, message: "this name/season combination already taken" }
  validate :full_name_unique_for_admin
  scope :order_by_created_at, -> { order(created_at: :desc) }

  def full_name
    "#{name} #{season}"
  end

  # assumes just 1 admin for now
  def admin
    users.joins(:league_auths)
         .find_by(league_auths: { role: :admin })
  end

  private

  def titleize_full_name
    self.name = name.strip.titleize
    self.season = season.strip.titleize
  end

  def full_name_unique_for_admin
    return unless creator

    duplicates = creator.leagues.where([ "name = ? and season = ?", name, season ])
    duplicates = duplicates.where.not(id: id) if persisted?
    error_message = "You already have a league named #{name} for Season #{season}"
    if duplicates.exists?
      # want 1 error message but both fields hlighted  - used in conjunction with skippin an error message in the form's league.errors.any? loop
      errors.add(:name, error_message)
      errors.add(:season, "")
    end
  end
end

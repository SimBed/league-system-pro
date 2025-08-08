class League < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :league_auths, dependent: :destroy
  has_many :users, through: :league_auths
  scope :order_by_created_at, -> { order(created_at: :desc) }

  def full_name
    "#{name} #{season}"
  end

  def winner_name
    leader = leader() # hopefully this sets local variable leader to the return of method leader
    return "not started" if leader.nil?

    if complete?
      leader.name
    else
      "#{leader.name} (leading)"
    end
  end
end

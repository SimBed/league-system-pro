class League < ApplicationRecord
  has_many :matches, dependent: :destroy
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

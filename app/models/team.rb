class Team < ApplicationRecord
  has_many :participations, as: :participatable, dependent: :destroy
end

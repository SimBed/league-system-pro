class Team < ApplicationRecord
  has_many :participations, as: :participant, dependent: :destroy
end

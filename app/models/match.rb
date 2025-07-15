class Match < ApplicationRecord
  belongs_to :league
  has_many :participations, dependent: :destroy
end

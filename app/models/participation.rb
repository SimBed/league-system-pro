class Participation < ApplicationRecord
  belongs_to :match
  belongs_to :participatable, polymorphic: true
end

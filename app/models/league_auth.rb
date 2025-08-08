class LeagueAuth < ApplicationRecord
  belongs_to :user
  belongs_to :league

  enum :role, { admin: 0, member: 1, viewer: 2 }
end

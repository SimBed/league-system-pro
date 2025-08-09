class PlayerAuth < ApplicationRecord
  belongs_to :user
  belongs_to :player

  enum :role, { admin: 0, member: 1 }
end

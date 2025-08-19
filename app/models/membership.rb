class Membership < ApplicationRecord
  belongs_to :player
  belongs_to :league
  scope :order_by_player_name, -> { joins(:player).order(:first_name, :last_name) }
end

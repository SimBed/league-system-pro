class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :league_auths, dependent: :destroy
  has_many :leagues, through: :league_auths
  has_many :player_auths, dependent: :destroy
  has_many :players, through: :player_auths
end

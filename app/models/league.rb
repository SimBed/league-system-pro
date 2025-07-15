class League < ApplicationRecord
  has_many :matches, dependent: :destroy

  def full_name
    "#{name} #{season}"
  end
end

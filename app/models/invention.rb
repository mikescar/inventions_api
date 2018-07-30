class Invention < ApplicationRecord
  has_and_belongs_to_many :bits

  validates :bits, presence: true
  validates :description, presence: true
  validates :email, length: { maximum: 255 } # TODO add email format validation
  validates :title, presence: true, length: { maximum: 255 }
  validates :username, length: { maximum: 255 }
end

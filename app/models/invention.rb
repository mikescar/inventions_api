class Invention < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :username, length: { maximum: 255 }
  validates :email, length: { maximum: 255 } # TODO add email format validation
end

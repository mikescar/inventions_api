class Invention < ApplicationRecord
  has_and_belongs_to_many :bits

  validates :bits, presence: true
  validates :description, presence: true
  validates :email, length: { maximum: 255 }, format: { allow_blank: true, with: /\A[\w\.]+@[\w\.]+\z/ }
  validates :title, presence: true, length: { maximum: 255 }
  validates :username, length: { maximum: 255 }

  before_save { self.materials.uniq! }
end

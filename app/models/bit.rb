class Bit < ApplicationRecord
  has_and_belongs_to_many :inventions

  validates :name, presence: true
end

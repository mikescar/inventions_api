class Bit < ApplicationRecord
  has_and_belongs_to_many :inventions

  validates :name, presence: true

  def as_json(_options = {})
    { id: id, name: name }
  end
end

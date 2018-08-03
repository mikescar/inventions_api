class Invention < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  has_and_belongs_to_many :bits

  validates :bits, presence: true
  validates :description, presence: true
  validates :email, length: { maximum: 255 }, format: { allow_blank: true, with: /\A[\w\.]+@[\w\.]+\z/ }
  validates :title, presence: true, length: { maximum: 255 }
  validates :username, length: { maximum: 255 }

  before_save { materials.uniq! }

  # Escape user-defined fields to avoid XSS if frontend forgets to do so before displaying to the user
  #   I prefer to store in database as-is for easier debugging, instead of sanitizing prior to saving.
  def as_json(_options = {})
    {
      bits: bits,
      created_at: created_at,
      description: sanitize(description),
      email: sanitize(email),
      id: id,
      title: sanitize(title),
      updated_at: updated_at,
      username: sanitize(username),
    }
  end
end

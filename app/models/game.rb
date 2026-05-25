class Game < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :nullify

  validates :collection_status, inclusion: { in: ["owned", "wishlist", "pending", "skipped"] }
end

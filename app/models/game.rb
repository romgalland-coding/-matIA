class Game < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :nullify

  validates :collection_status, inclusion: { in: ["played", "wishlist", "pending", "skipped"] }
  # validate :platforms_must_be_valid

  # private

  # def platforms_must_be_valid
  #   return if platform.blank?

  #   invalid_platforms = platform - self.class::PLATFORMS
  #   if invalid_platforms.any?
  #     errors.add(:platform, "contient des plateformes invalides : #{invalid_platforms.join(', ')}")
  #   end
  # end
end

class Game < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :nullify

  EDITION_SUFFIXES = /
    \s*[:\-–]\s*
    (director'?s\ cut|definitive\ edition|complete\ edition|
     game\ of\ the\ year|goty|remastered|enhanced\ edition|
     ultimate\ edition|anniversary\ edition|\w+\ edition)
    \s*$
  /xi

  def self.normalize_title(title)
    title.sub(EDITION_SUFFIXES, "").strip
  end

  SORT_FIELDS = %w[title platform genre release_date sales].freeze
  SORT_DIRECTIONS = %w[asc desc].freeze

  scope :sorted_by, lambda { |sort, direction|
    sort = "title" unless SORT_FIELDS.include?(sort)
    direction = "asc" unless SORT_DIRECTIONS.include?(direction)
    order(sort => direction)
  }

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

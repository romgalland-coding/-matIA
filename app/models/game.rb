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

  SORT_FIELDS = %w[title added_date metacritic platform genre release_date sales].freeze
  SORT_DIRECTIONS = %w[asc desc].freeze
  SORT_COLUMN_MAP = {
    "added_date" => "updated_at"
  }.freeze

  scope :sorted_by, lambda { |sort, direction|
    sort = "title" unless SORT_FIELDS.include?(sort)
    direction = "asc" unless SORT_DIRECTIONS.include?(direction)
    column = SORT_COLUMN_MAP.fetch(sort, sort)
    order(column => direction)
  }

  scope :filter_by, lambda { |platform, genre, studio|
    games = all
    games = games.where("? = ANY(platform)", platform) if platform.present?
    games = games.where(genre: genre) if genre.present?
    games = games.where(studio: studio) if studio.present?
    games
  }

  validates :collection_status, inclusion: { in: ["played", "wishlist", "pending", "skipped"] }

  def metacritic_color
    return nil unless metacritic.present?

    if metacritic >= 90 then "green-dark"
    elsif metacritic >= 80 then "green"
    elsif metacritic >= 75 then "green-light"
    elsif metacritic >= 50 then "yellow"
    else "red"
    end
  end
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

class User < ApplicationRecord
  PLATFORMS = [
    "PC",
    "PlayStation 5",
    "PlayStation 4",
    "PlayStation 3",
    "Xbox Series S/X",
    "Xbox One",
    "Xbox 360",
    "Nintendo Switch",
    "Nintendo 3DS",
    "iOS",
    "Android",
    "macOS",
    "Linux"
  ].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats

  validates :user_name, presence: true
end

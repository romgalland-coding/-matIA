class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :game, optional: true

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "Tu as atteint la limite de #{MAX_USER_MESSAGES} messages par chat.")
    end
  end
end

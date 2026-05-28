class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :game, optional: true

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  after_create_commit :broadcast_append_to_chat

  private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "Tu as atteint la limite de #{MAX_USER_MESSAGES} messages par chat.")
    end
  end

  def broadcast_append_to_chat
    broadcast_append_to chat, target: "chat-messages", partial: "messages/message", locals: { message: self }
  end
end

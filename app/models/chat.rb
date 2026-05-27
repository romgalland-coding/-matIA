class Chat < ApplicationRecord
  DEFAULT_TITLE = "nouvelle conversation"

  # Claude reco
  TITLE_PROMPT = <<~PROMPT
    Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
    Return ONLY the title, no markdown, no punctuation, no explanation, nothing else.
  PROMPT

  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  def generate_title_from_conversation
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end
end

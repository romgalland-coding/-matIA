class Chat < ApplicationRecord
  DEFAULT_TITLE = "nouvelle conversation"

  # Claude reco
  TITLE_PROMPT = <<~PROMPT
    Based on the conversation below, generate a short 3-to-5-word chat title that captures how the user wants to play (solo/multiplayer), their platform, and their mood or genre.
    Examples: "Solo action RPG on PS5", "Co-op horror on PC", "Open world adventure Switch".
    Return ONLY the title, no markdown, no punctuation, no explanation, nothing else.
  PROMPT

  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  def generate_title_from_conversation
    return unless title == DEFAULT_TITLE
    return unless messages.where(role: "assistant").where.not(game_id: nil).exists?

    conversation = messages.order(:created_at).map do |m|
      "#{m.role.capitalize}: #{m.content}"
    end.join("\n")

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(conversation)
    update(title: response.content)
  end
end

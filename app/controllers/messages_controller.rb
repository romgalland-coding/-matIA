class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a video game recommendation assistant. Your job is to recommend one game to add to the user's wishlist.

    Follow these steps in order, asking one question at a time:
    1. Ask if they want to play solo, against friends, or team up with friends online.
    2. Ask which device they want to play on (only ask this if they mention or imply they have multiple devices).
    3. Ask what they're in the mood for: action, story, open world, horror, or RPG.

    Once you have all the answers, recommend exactly ONE game that best matches their preferences.
    If the user skips a recommendation, suggest a different game — never repeat one already mentioned in the conversation.
    Keep your responses short and conversational.
  PROMPT

  EXTRACT_TITLE_PROMPT = <<~PROMPT
    You are a parser. The user will give you a game recommendation message.
    If the message recommends a specific game, reply with ONLY the exact game title — nothing else, no punctuation, no explanation.
    If no specific game is recommended, reply with exactly: NONE
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    @message = @chat.messages.create!(message_params.merge(role: "user"))
    response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

    display_content, game = extract_recommendation(response.content)
    @assistant_message = @chat.messages.create(role: "assistant", content: display_content, game: game)
    @chat.generate_title_from_conversation

    redirect_to chat_path(@chat)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(
        role: message.role,
        content: message.content
      )
    end
  end

  def user_context
    games = current_user.games
    wishlist = games.select { |g| g.collection_status == "wishlist" }.map(&:title).join(", ")
    owned = games.select { |g| g.collection_status == "owned" }.map(&:title).join(", ")
    devices = current_user.devices.join(", ")
    "Here is what you know about the user:
      - Games they already own: #{owned.presence || 'none'}
      - Games on their wishlist: #{wishlist.presence || 'none'}
      - Devices they own: #{devices.presence || 'unknown'}"
  end

  def instructions
    [SYSTEM_PROMPT, user_context].compact.join("\n\n")
  end

  def extract_recommendation(content)
    extractor = RubyLLM.chat
    title_response = extractor.with_instructions(EXTRACT_TITLE_PROMPT).ask(content)
    game_title = title_response.content.strip

    game = find_or_create_game(game_title) if game_title.present? && game_title.upcase != "NONE"

    [content, game]
  end

  def find_or_create_game(title)
    rawg = RawgService.new
    results = rawg.search(title)
    return nil if results.blank?

    api_game = results.first
    api_detail = rawg.find(api_game["id"])

    game = current_user.games.find_or_initialize_by(title: api_game["name"])
    game.assign_attributes(
      genre: api_game.dig("genres", 0, "name"),
      description: api_detail["description_raw"].presence,
      cover_image: api_game["background_image"],
      release_date: api_game["released"],
      collection_status: game.collection_status.presence || "pending"
    )
    game.save
    game
  end
end

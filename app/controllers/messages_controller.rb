class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a video game recommendation assistant. Your job is to recommend one game to add to the user's wishlist.

    Follow these steps in order, asking one question at a time:
    1. Ask if they want to play solo, against friends, or team up with friends online.
    2. Ask which device they want to play on (only ask this if they mention or imply they have multiple devices).
    3. Ask what genre of game they're in the mood for and give some examples like RPG, FPS, open world, action, etc.

    Once you have all the answers, use the search_game tool to find a real game that matches the user's preferences.
    The game cannot already be in the user's wishlist or owned games.
    If the user skips a recommendation, use the search_game tool to find a different game — never repeat a game already mentioned or already in the user's collection.
    Keep your responses short and conversational.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    @message = @chat.messages.create!(message_params.merge(role: "user"))

    # Message assistant vide → affiche "..." immédiatement
    @assistant_message = @chat.messages.create!(role: "assistant", content: "")

    # Instancier le tool avec le user courant
    @search_game_tool = SearchGameTool.new(user: current_user)

    ask_llm

    # Sauvegarder le contenu final + associer le jeu si le tool a été appelé
    @assistant_message.update(
      content: @assistant_message.content,
      game:    @search_game_tool.found_game
    )
    broadcast_replace(@assistant_message) if @search_game_tool.found_game
    @chat.generate_title_from_conversation
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def ask_llm
    @ruby_llm_chat.with_instructions(instructions)
    @ruby_llm_chat.with_tool(@search_game_tool)
    @ruby_llm_chat.ask(@message.content) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target:  helpers.dom_id(message),
      partial: "messages/message",
      locals:  { message: message }
    )
  end

  def user_context
    games    = current_user.games
    wishlist = games.select { |g| g.collection_status == "wishlist" }.map(&:title).join(", ")
    owned = games.select { |g| g.collection_status == "played" }.map(&:title).join(", ")
    devices = current_user.devices.join(", ")
    "Here is what you know about the user:
      - Games they already own: #{owned.presence || 'none'}
      - Games on their wishlist: #{wishlist.presence || 'none'}
      - Devices they own: #{devices.presence || 'unknown'}"
  end

  def instructions
    [SYSTEM_PROMPT, user_context].compact.join("\n\n")
  end
end

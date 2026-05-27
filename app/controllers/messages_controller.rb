class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a video game recommendation assistant. Your job is to recommend games to add to the user's wishlist.

    Follow these steps in order, asking one question at a time:
    1. Ask if they want to play solo, against friends, or team up with friends online.
    2. Ask which device they want to play on (only ask this if they mention or imply they have multiple devices).
    3. Ask what they're in the mood for: action, story, open world, horror, or RPG.

    Once you have all the answers, recommend 2-3 games that match their preferences.
    Keep your responses short and conversational.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    # @chat.messages.create!(role: "user", content: params[:message][:content])
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

    @assistant_message = @chat.messages.create(role: "assistant", content: response.content)
    @chat.generate_title_from_conversation

    # @chat.messages.each do |msg|
    #   llm_chat.add_message(role: msg.role, content: msg.content)
    # end
    # response = llm_chat.complete

    # @chat.messages.create!(role: "assistant", content: response.content)

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
end

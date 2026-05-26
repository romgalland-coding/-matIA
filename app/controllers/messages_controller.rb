class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])

    @chat.messages.create!(role: "user", content: params[:message][:content])
    llm_chat = RubyLLM.chat
    llm_chat.with_instructions(system_prompt)

    @chat.messages.each do |msg|
      llm_chat.add_message(role: msg.role, content: msg.content)
    end
    response = llm_chat.complete

    @chat.messages.create!(role: "assistant", content: response.content)

    redirect_to chat_path(@chat)
  end

  private

  def system_prompt
    <<~PROMPT
      You are a video game recommendation assistant. Your job is to recommend games to add to the user's wishlist.

      Follow these steps in order, asking one question at a time:
      1. Ask if they want to play solo, against friends, or team up with friends online.
      2. Ask which device they want to play on (only ask this if they mention or imply they have multiple devices).
      3. Ask what they're in the mood for: action, story, open world, horror, or RPG.

      Once you have all the answers, recommend 2-3 games that match their preferences.
      Keep your responses short and conversational.
    PROMPT
  end
end

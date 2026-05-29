class ChatsController < ApplicationController
  def index
    @chats = current_user.chats.order(updated_at: :desc)
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @limit_reached = @messages.where(role: "user").count >= Message::MAX_USER_MESSAGES
  end

  def create
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.user = current_user

    if @chat.save
      @chat.messages.create!(
        role: "assistant",
        content: "Hey **#{current_user.user_name}**! 3 questions and I'll find your next game. Let's go? 🚀"
      )
      redirect_to chat_path(@chat)
    else
      @chats = @game.chats.where(user: current_user)
      render "games/show"
    end
  end
end

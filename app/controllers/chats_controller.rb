class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
  end

  def create
    @chat = Chat.new(title: "untitled")
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @game.chats.where(user: current_user)
      render "games/show"
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :games, only: %i(update destroy show index)

  resources :chats, only: [:index, :show, :create]  do
    resources :messages, only: [:create]
  end

  resource :profile, only: %i(show edit update)
end

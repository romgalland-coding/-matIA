class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @cover_images = Game.where.not(cover_image: nil).limit(6).pluck(:cover_image).shuffle
  end
end

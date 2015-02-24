class FavoritesController < ApplicationController

  before_filter 'authenticate_user!'
  def create
    @favorite = Favorite.new
    @favorite.hashtag = params[:hashtag]
    @favorite.user = current_user

    respond_to do |format|
      if @favorite.save
        format.json { render json: @favorite, status: :created, location: @favorite }
      else
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end
end

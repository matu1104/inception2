class HomeController < ApplicationController

  before_filter :authenticate_user!
  def index
    begin
      @trending_topics = TwitterConnection.instance.trending_topics
      @hashtag_name = (params[:hash].nil? ? @trending_topics[0] : params[:hash])
      @tweets = TwitterConnection.instance.tweets_with_hashtag(@hashtag_name, 10)
      @favorite_trends = current_user.favorites
    rescue
      render :error
    end
  end
end

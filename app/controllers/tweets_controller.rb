class TweetsController < ApplicationController
  # GET /tweets/:hash
  def index
    respond_to do |format|
      begin
        @tweets = TwitterConnection.instance.tweets_with_hashtag(params[:hash], 10)
        format.json { render json: @tweets, status: :ok }
      rescue
        format.json {render json: '{}', status: :unprocessable_entity}
      end
    end
  end
end

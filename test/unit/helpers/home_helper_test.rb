require 'test_helper'

class HomeHelperTest < ActionView::TestCase
  context 'user_bio' do
    context 'is not empty' do
      setup do
        @tweet_with_bio = Tweet.new
        @tweet_with_bio.user_bio = 'bio'
      end
      should 'return user bio' do
        assert_equal @tweet_with_bio.user_bio, user_bio(@tweet_with_bio)
      end
    end

    context 'is empty' do
      setup do
        @tweet_without_bio = Tweet.new
        @tweet_without_bio.user_bio = ''
        @tweet_without_bio.username = 'user'
      end
      should 'return a message: "the use has not description"' do
        assert_equal "<div class=\"alert alert-danger\" id=\"error_explanation\" role=\"alert\"><strong>#{@tweet_without_bio.username}</strong> hasn&#x27;t got a description </div>",
                     user_bio(@tweet_without_bio)
      end
    end
  end
end

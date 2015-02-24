require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context 'User is not authenticated' do
    should 'return unauthorized response' do
      post :create, {hashtag: '#myhashtag', format: :json}
      assert_response :unauthorized
    end
  end

  context 'User is authenticated' do
    setup do
      @user = User.find_by_email('user1@mysite.com')
      sign_in @user
    end

    context 'User does not have hashtag parameter as favorite' do
      should 'add hashtag to user favorites trends' do
        post :create, {hashtag: '#myhashtag', format: :json}
        assert_response :created
        assert @user.favorites.any? {|favorite| favorite.hashtag == '#myhashtag'}
      end
    end

    context 'User has hashtag paramter as favorite' do
      setup do
        @user = User.find_by_email('user1@mysite.com')
        sign_in @user
      end

      should 'return unprocessable_entity response' do
        post :create, {hashtag: '#myhashtag', format: :json}
        assert_response :created

        post :create, {hashtag: '#myhashtag', format: :json}
        assert_response :unprocessable_entity
      end
    end

    context 'Hash tag parameter is not set' do
      should 'return unprocesable_entity response' do
        post :create, {format: :json}
        assert_response :unprocessable_entity
      end
    end
  end
end

require 'test_helper'
require 'devise'
require 'fakeweb'


class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    FakeWeb.allow_net_connect = false
    twitterConnectionLocal
  end

  context 'User not authenticated' do
    should 'redirect to login page' do
      get :index
      assert_response :redirect
      assert_redirected_to login_path
    end
  end

  context 'User authenticated' do
    setup do
      sign_in  User.find_by_email('user1@mysite.com')
    end

    should 'get home page' do
      get :index
      assert_response :success

      assert_home_page
    end

    should 'set variables trends, tweets and hashtag' do
      get :index

      assert_not_nil assigns(:trending_topics)
      assert_not_nil assigns(:tweets)
      assert_not_nil assigns(:hashtag_name)
    end

    context 'Search for a hashtag' do

      should 'set variable tweets and hashtag with the searched hash' do
        get(:index, { 'hash' => '#GanaPuntosSi' })
        assert_response :success

        assert_home_page

        assert_not_nil assigns(:trending_topics)
        assert_not_nil assigns(:tweets)
        assert_equal '#GanaPuntosSi', assigns(:hashtag_name)
      end
    end

    context 'Connection to Twitter error' do
      setup do
        FakeWeb.clean_registry
      end

      should 'render error page' do
        get :index
        assert_response :success

        assert_error_page
      end
    end

    context 'Twitter rate limit exceeded' do
      setup do
        twitterConnectionLocal(true)
      end

      context 'get index' do
        should 'render error page' do
          get :index
          assert_response :success

          assert_error_page
        end
      end

      context 'Search for a hashtag' do
        should 'render error page' do
          get(:index, { 'hash' => '#GanaPuntosSi' })
          assert_response :success

          assert_error_page
        end
      end
    end
  end


  def assert_error_page
    assert_template layout: 'layouts/application'
    assert_template partial: 'devise/shared/_navbar'
    assert_template 'home/error'
    assert_select('body') { |body| assert_match /In this moment we can't connect with Twitter!/, body.to_s}
  end

  def assert_home_page
    assert_template layout: 'layouts/application'
    assert_template partial: 'devise/shared/_navbar'
    assert_template partial: 'home/_list_tweets'
    assert_template 'home/index'
  end
end

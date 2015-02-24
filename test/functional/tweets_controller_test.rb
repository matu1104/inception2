require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  def setup
    FakeWeb.allow_net_connect = false
  end

  context 'index' do

    context 'Twitter API responds with an error' do
      setup do
        twitterConnectionLocal(true)
      end
      should 'return unprocesable_entity response' do
        get :index, {hash: '#GanaPuntosSi', format: :json}
        assert_response :unprocessable_entity
        assert_nil assigns(:tweets)
      end
    end

    context 'Twitter API sends requested tweets' do
      setup do
        twitterConnectionLocal
      end
      should 'response success' do
        get :index, {hash: '#GanaPuntosSi', format: :json}
        assert_response :ok
        assert assigns(:tweets)
      end
    end
  end
end

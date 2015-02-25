require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = FactoryGirl.create(:user)
  end

  context 'user admin is not authenticated' do
    context 'get index' do
      should 'redirect to login' do
        get :index
        assert_redirected_to login_path
      end
    end

    context 'get new' do
      should 'redirect to login' do
        get :new
        assert_redirected_to login_path
      end
    end

    context 'create user' do
      should 'redirect to login' do
        post :create, user: { username: 'newuser', email: 'newuser@mysite.com', password: 'cualquiera', admin: false }
        assert_redirected_to login_path
      end
    end

    context 'show user' do
      should 'redirect to login' do
        get :show, id: @user
        assert_redirected_to login_path
      end
    end

    context 'get edit' do
      should 'redirect to login' do
        get :edit, id: @user
        assert_redirected_to login_path
      end
    end

    context 'update user' do
      should 'redirect to login' do
        put :update, id: @user, user: {  }
        assert_redirected_to login_path
      end
    end

    context 'destroy user' do
      should 'redirect to login' do
        delete :destroy, id: @user
      end
    end
  end

  context 'User that is not admin is authenticated' do
    setup do
      sign_in @user
    end
    context 'get index' do
      should 'redirect to login' do
        get :index
        assert_redirected_to root_path
      end
    end

    context 'get new' do
      should 'redirect to login' do
        get :new
        assert_redirected_to root_path
      end
    end

    context 'create user' do
      should 'redirect to login' do
        post :create, user: { username: 'newuser', email: 'newuser@mysite.com', password: 'cualquiera', admin: false }
        assert_redirected_to root_path
      end
    end

    context 'show user' do
      should 'redirect to login' do
        get :show, id: @user
        assert_redirected_to root_path
      end
    end

    context 'get edit' do
      should 'redirect to login' do
        get :edit, id: @user
        assert_redirected_to root_path
      end
    end

    context 'update user' do
      should 'redirect to login' do
        put :update, id: @user, user: {  }
        assert_redirected_to root_path
      end
    end

    context 'destroy user' do
      should 'redirect to login' do
        delete :destroy, id: @user
        assert_redirected_to root_path
      end
    end
  end

  context 'user admin is authenticated' do
    setup do
      @admin = FactoryGirl.create(:admin)
      sign_in @admin
    end

    should 'get index' do
      get :index
      assert_response :success
      assert_not_nil assigns(:users)
    end

    should 'get new' do
      get :new
      assert_response :success
    end

    should 'create user' do
      assert_difference('User.count') do
        post :create, user: { username: 'newuser', email: 'newuser@mysite.com', password: 'cualquiera', admin: false }
      end

      assert_redirected_to user_path(assigns(:user))
    end

    should 'show user' do
      get :show, id: @user
      assert_response :success
    end

    should 'get edit' do
      get :edit, id: @user
      assert_response :success
    end

    should 'update user' do
      put :update, id: @user, user: { password: '' }
      assert_redirected_to user_path(assigns(:user))
    end

    should 'destroy user' do
      assert_difference('User.count', -1) do
        delete :destroy, id: @user
      end

      assert_redirected_to users_path
    end
  end
end

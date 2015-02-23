class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to login_path
    end
  end
end

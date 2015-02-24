class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      respond_to do |format|
        format.html { redirect_to login_path }
        format.json { render json: '{}', status: :unauthorized }
      end
    end
  end
end

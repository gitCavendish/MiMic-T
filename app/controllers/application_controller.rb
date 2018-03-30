class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :log_in

  def fake_login
    log_in(User.first)
    redirect_to root_url
  end

  private

  def logged_in_user
    unless current_user
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end

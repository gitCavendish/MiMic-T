class SessionsController < ApplicationController
  def new
  end

  def create
    # find a user by email
    user = User.find_by(email: params[:session][:email])
    # authenticate password based on founded user
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combinations"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

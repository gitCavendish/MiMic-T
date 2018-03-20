class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) # 非最终版本
    if @user.save
      flash[:success] = "Welcome to Sample App!" # 这里的flash content实际是为后面view中用到作准备
      redirect_to @user # or user_url(@user)
    else
      render "new"
    end
  end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end

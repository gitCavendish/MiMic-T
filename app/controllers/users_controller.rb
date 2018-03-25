class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) # 非最终版本
    if @user.save
      # log_in(@user)
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account" # 这里的flash content实际是为后面view中用到作准备
      redirect_to root_url
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

    private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless current_user
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

end

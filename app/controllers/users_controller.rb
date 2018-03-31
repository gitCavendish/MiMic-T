class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
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
    @microposts = @user.microposts.paginate(page: params[:page])
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

  # get following_user_path
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page]) # 两个不同path拿到的@users是不同的
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def like_post
    @micropost = Micropost.find(params[:id])
    like = @micropost.likes.find_by(user_id: current_user.id)
    if !like
      @micropost.likes.create(user_id: current_user.id)
      @likes = @micropost.likes.count
      respond_to do |format|
         format.html { redirect_back_or root_path}
         format.js
      end
    else
      unlike_post(like)
    end
  end

  def unlike_post(like)
    @micropost = Micropost.find(params[:id])
    like.destroy
    @likes = @micropost.likes.count
    respond_to do |format|
       format.html { redirect_back_or root_path}
       format.js
    end
  end

    private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :icon)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

end

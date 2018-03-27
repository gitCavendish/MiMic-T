class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js {  }
    end

  end

  def destroy
    # params[:id] 对应的 relationship 已经在 users/_unfollow 的 form_for 中被找到
    # form_for(current_user.active_relationships.find_by(followed_id: @user.id)
    # 第一步拿到 current_user 关联的 relationships, 然后找到其中 followed_id 是 @user.id(也就是当前访问的用户页面的id)
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js {  }
    end
  end

end

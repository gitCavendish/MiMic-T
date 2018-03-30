class CommentsController < ApplicationController
  before_action :logged_in_user
  def new
  end

  def create
#    debugger
    if !params[:comment][:message].blank?
      @comment = Comment.new(micropost_id: params[:id], user_id: current_user.id)
      @comment.message = params[:comment][:message]
      if @comment.save
        flash[:success] = "Created comment successfully."
      else
        flash[:warning] = "Comment to short! Please try again."
      end
    end
    redirect_back_or root_url
  end

  def destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:message)
    end



end

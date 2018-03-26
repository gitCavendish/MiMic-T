class StaticPagesController < ApplicationController
  def help
  end

  def home
    if current_user
      @micropost = current_user.microposts.new if current_user
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end

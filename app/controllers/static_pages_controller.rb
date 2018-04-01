require 'will_paginate/array'
class StaticPagesController < ApplicationController
  def help
  end

  def home
    @camp = Camp.first
    if current_user
      @micropost = current_user.microposts.new if current_user
      @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 8)
    else
      @feed_items = Micropost.all.sample(15).paginate(page: params[:page], :per_page => 8)
    end
  end

  def about
  end

  def contact
  end
end

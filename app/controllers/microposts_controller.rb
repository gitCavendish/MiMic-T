class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy


  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      if params[:micropost][:bucket]
        params[:micropost][:bucket][:picture].each do |pic|
          @micropost.buckets.create(picture: pic)
        end
      end 
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost delete"
    #redirect_to request.referrer || root_url
    redirect_back(fallback_location: root_url)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, bucket_attributes: [:id, :micropost_id, :picture])
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end

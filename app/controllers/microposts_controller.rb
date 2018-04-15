class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]


  def create
    @micropost = current_user.microposts.build(micropost_params)

    if params[:micropost][:bucket]
      if params[:micropost][:bucket][:picture].size > 6
        flash[:warning] = "Too many photos, maximum 6"
      else
        @micropost.save
        params[:micropost][:bucket][:picture].each do |pic|
          @micropost.buckets.create(picture: pic)
        end
      end
    else
      @micropost.save
    end
    respond_to do |format|
        format.html { redirect_back(fallback_location: root_url)}
        format.js
    end
  end


  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url)}
      format.js
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    @micropost.comments.where("been_read = ?", false).each { |c| c.toggle!(:been_read) }
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

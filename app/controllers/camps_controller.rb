class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /camps
  # GET /camps.json
  def index
    @camps = Camp.order(created_at: 'desc').paginate(page: params[:page], per_page: 10)
  end

  # GET /camps/1
  # GET /camps/1.json
  def show
    @participators = @camp.participators
  end

  # GET /camps/new
  def new
    @camp = Camp.new
  end

  # GET /camps/1/edit
  def edit
  end

  # POST /camps
  # POST /camps.json
  def create
    @camp = current_user.camps.new(camp_params)

    respond_to do |format|
      if @camp.save
        format.html { redirect_to @camp, notice: 'Camp was successfully created.' }
        format.json { render :show, status: :created, location: @camp }
      else
        format.html { render :new }
        format.json { render json: @camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /camps/1
  # PATCH/PUT /camps/1.json
  def update
    respond_to do |format|
      if @camp.update(camp_params)
        format.html { redirect_to @camp, notice: 'Camp was successfully updated.' }
        format.json { render :show, status: :ok, location: @camp }
      else
        format.html { render :edit }
        format.json { render json: @camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /camps/1
  # DELETE /camps/1.json
  def destroy
    @camp.destroy
    respond_to do |format|
      format.html { redirect_to camps_url, notice: 'Camp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def participate
    @relation = current_user.participator_relationships.new
    if @relation.camp_id = params[:id]
      @relation.save
      flash[:success] = "Successfully participate this camp."
      redirect_back fallback_location: camps_path
    end
  end

  def quit
    relation = current_user.participator_relationships.find_by(camp_id: params[:id])
    relation.destroy
    flash[:warning] = "Successfully quit this camp."
    redirect_back fallback_location: camps_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp
      @camp = Camp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camp_params
      params.require(:camp).permit(:title, :venue, :intro, :time, :picture)
    end
end

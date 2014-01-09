class PicturesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  def index
    @pictures = current_user.pictures.where(report_id: nil)
  end

  def show
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.user = current_user

    respond_to do |format|
      if @picture.save
        format.html { redirect_to pictures_path,
          notice: 'Picture was successfully created.' }
        format.json { render json: {
          status: :ok,
          message: 'Picture was successfully created.'
        } }
      else
        format.html { render :new }
        format.json { render json: {
          status: :error,
          message: @picture.errors.full_messages
        } }
      end
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def picture_params
      params.require(:picture).permit(:user_id, :file, :description)
    end
end

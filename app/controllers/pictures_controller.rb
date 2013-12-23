class PicturesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  def index
    @pictures = current_user.pictures.all
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
        format.html { redirect_to @picture,
          notice: 'Picture was successfully created.' }
        format.json { render action: 'show',
          status: :created, location: @picture }
      else
        format.html { render action: 'new' }
        format.json { render json: @picture.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def picture_params
      params.require(:picture).permit(:user_id, :file)
    end
end

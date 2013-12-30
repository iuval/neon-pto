class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  def index
    @reports = Report.all
  end

  def show
  end

  def new
    @report = Report.new
    @pictures = current_user.pictures.where('extract(month from created_at) = ?', Date.today.month)
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user
    params[:report][:picture_ids].each do |picture_id|
      picture = current_user.pictures.where(id: picture_id).first
      if picture
        @report.pictures << picture
      end
    end

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report,
          notice: 'Report was successfully created.' }
        format.json { render action: 'show',
          status: :created, location: @report }
      else
        format.html { render action: 'new' }
        format.json { render json: @report.errors,
          status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def report_params
      params.require(:report).permit(:user_id, :body, :title, :date, :picture_ids)
    end
end

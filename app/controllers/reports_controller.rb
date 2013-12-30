class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  def index
    @reports = Report.where('extract(month from created_at) = ?', Date.today.month)
  end

  def result
    @reports = Report.where('extract(month from created_at) = ?', 1.hour.ago.month)
    if @reports.length > 0
      @total_love = 0
      @rated_reports = []
      @reports.each do |r|
        @rated_reports << { report: r, love: r.love }
        @total_love += r.love
      end
      @rated_reports.sort_by{ |r| r[:love] }
      @scale = 100 / @total_love
    end
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

  def toggle_love
    report = Report.find(params[:id])
    if report
      love = current_user.user_love_reports.where(report_id: report).first
      love_count = current_user.this_month_love_count
      if love
        love.destroy
        love_count -= 1
      else
        if love_count < UserLoveReport.max_love_per_month
          current_user.user_love_reports.create(report: report)
          love_count += 1
        else
          render json: {
            status: :error,
            message: "You already loved #{UserLoveReport.max_love_per_month} reports this month."
          } and return
        end
      end
      render json: {
        status: :ok,
        message: "#{love_count} out of #{UserLoveReport.max_love_per_month} loves this month."
      }
    else
      render json: { status: :error, message: 'Report does not exists.' }
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

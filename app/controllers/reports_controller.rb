class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_report, only: [:show, :update, :destroy]

  def index
    today_month = Date.today.strftime("%m-%Y")
    if params[:date]
      @date = DateTime.strptime(params[:date], '%m-%Y').strftime("%m-%Y")
    else
      @date = today_month
    end
    @is_current_month = @date == today_month
    split = @date.split '-'
    if split.length == 2
      @reports = Report.published
        .where('extract(month from date) = ?', split[0])
        .where('extract(year from date) = ?', split[1])
    end
  end

  def show
    unless @report.published
      flash[:alert] = I18n.t('report.not_published')
      redirect_to reports_path
    end

    @is_current_month =  @report.date.strftime("%m-%Y") == Date.today.strftime("%m-%Y")
  end

  def edit
    @report = current_user.this_month_report
    @pictures = current_user.pictures_without_report
  end

  def new
    @report = Report.new
    @pictures = current_user.pictures_without_report
  end

  def create
    if current_user.has_this_month_report?
      redirect_to root_path
    else
      @report = current_user.reports.new(report_params)
      if params[:report][:picture_ids]
        params[:report][:picture_ids].each do |picture_id|
          picture = current_user.pictures.where(id: picture_id).first
          if picture
            @report.pictures << picture
          end
        end
      end

      respond_to do |format|
        if @report.save
          format.html { redirect_to @report,
            notice: 'Report was successfully created.' }
          format.json { render :show,
            status: :created, location: @report }
        else
          format.html { render :new }
          format.json { render json: @report.errors,
            status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @report.update_attributes(report_params)
    pictures = []
    if params[:report][:picture_ids]
      params[:report][:picture_ids].each do |picture_id|
        picture = current_user.pictures.where(id: picture_id).first
        if picture
          pictures << picture
        end
      end
    end
    @report.pictures = pictures

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report,
          notice: 'Report was successfully updated.' }
        format.json { render :show,
          status: :created, location: @report }
      else
        format.html {
          @pictures = current_user.pictures_without_report
          render :edit
        }
        format.json { render json: @report.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def toggle_love
    report = Report.find(params[:id])
    if report
      if report.date.strftime("%m-%Y") == Date.today.strftime("%m-%Y")
        love_count = current_user.toggle_love report
        if love_count == UserLoveReport.max_love_per_month
          render json: {
            status: :error,
            message: "You already loved #{UserLoveReport.max_love_per_month} reports this month."
          } and return
        end
        render json: {
          status: :ok,
          message: "#{love_count} out of #{UserLoveReport.max_love_per_month} loves this month.",
        }
      else
        render json: { status: :error, message: 'You cannot love an old report.' }
      end
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
      params.require(:report).permit(:user_id, :body, :title, :date, :published, :picture_ids)
    end
end

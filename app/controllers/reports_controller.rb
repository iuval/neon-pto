class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_report, only: [:show, :destroy]

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
    @report = current_user.reports.where(id: params[:id]).first
    if @report
      revised_params = report_params
      revised_params[:picture_ids] ||= []
      @report.update_attributes(revised_params)
    else
      flash[:error] = I18n.t 'report.not_authorized'
      redirect_to reports_path and return
    end

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
    love_value = params[:value]
    if love_value and love_value.match /\A\d+?\Z/
      love_value = love_value.to_i
      report = Report.find(params[:id])
      if report
        if report.date.strftime("%m-%Y") == Date.today.strftime("%m-%Y")
          love_hash = current_user.toggle_love(report, love_value)
          if love_hash[:init] != love_hash[:final]
            render json: {
              status: :ok,
              message: "#{love_hash[:final]} out of #{UserLoveReport.max_love_per_month} loves this month.",
            }
          else
            render json: {
              status: :error,
              message: "You only have #{UserLoveReport.max_love_per_month - love_hash[:init]} loves left."
            }
          end
        else
          render json: { status: :error, message: 'You cannot love an old report.' }
        end
      else
        render json: { status: :error, message: 'Report does not exists.' }
      end
    else
      render json: { status: :error, message: 'Love value must be a number.' }
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
      params.require(:report).permit(:user_id, :body, :title, :date, :published, picture_ids: [])
    end
end

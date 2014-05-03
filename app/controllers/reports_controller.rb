class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_report, only: [:show, :destroy]

  def index
    if params[:date]
      split =  params[:date].split '-'
      if split.length == 2
        @date = DateTime.strptime(params[:date], '%m-%Y')
      else
        @date = Date.today
      end
    else
      @date = Date.today
    end
    @last_day = @date.at_beginning_of_month.next_month + Report::NEXT_MONTH_DAYS_TO_VOTE.days
    @can_vote = @last_day >= Date.today
    # TODO: have two field in reports table, one for month and one for year, instead of one for both
    @reports = Report.published.where(month: @date.month, year: @date.year)
    @date    = @date.strftime("%m-%Y")
  end

  def show
    unless @report.published
      flash[:alert] = I18n.t('report.not_published')
      redirect_to reports_path
    end
    @last_day = Date.today.at_beginning_of_month.next_month + Report::NEXT_MONTH_DAYS_TO_VOTE.days
    @can_vote = @report.can_vote?
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
      revised_params = report_params
      revised_params[:day]   = revised_params.delete('date(3i)')
      revised_params[:month] = revised_params.delete('date(2i)')
      revised_params[:year]  = revised_params.delete('date(1i)')
      @report = current_user.reports.new(revised_params)
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
      revised_params[:day]   = revised_params.delete('date(3i)')
      revised_params[:month] = revised_params.delete('date(2i)')
      revised_params[:year]  = revised_params.delete('date(1i)')
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
        if report.can_vote?
          love_hash = current_user.toggle_love(report, love_value)
          if love_hash[:init] != love_hash[:final]
            render json: {
              status: :ok,
              message: t('report.ok_love',
                         remaining: UserLoveReport::MAX_LOVE_PER_MONTH - love_hash[:final],
                         value: love_hash[:final],
                         total: UserLoveReport::MAX_LOVE_PER_MONTH
                        )
            }
          else
            render json: {
              status: :error,
              message: t('report.no_love',
                         remaining: UserLoveReport::MAX_LOVE_PER_MONTH - love_hash[:final]
                        )
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

class SupportsController < ApplicationController
  def send_feedback
    SupportMailer.feedback_email(current_user,
      params[:subject],
      params[:body]).deliver
    flash[:notice] = I18n.t 'support.email_sent'
    redirect_to reports_path
  end
end

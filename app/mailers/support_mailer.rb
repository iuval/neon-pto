class SupportMailer < ActionMailer::Base
  default to: ENV['DEFAULT_MAILER_TO']
  default from: ENV['DEFAULT_MAILER_FROM']

  def feedback_email(user, subject, body)
    @user = user
    @body = body
    mail(subject: subject)
  end
end

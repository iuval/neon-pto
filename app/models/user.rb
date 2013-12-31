class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, email: true

  has_many :pictures
  has_many :reports
  has_many :user_love_reports

  def this_month_love_count
    user_love_reports.where('extract(month from created_at) = ?', Date.today.month).count
  end

  def this_month_report
    reports.where('extract(month from created_at) = ?', Date.today.month).first
  end

  def has_this_month_report?
    !this_month_report.nil?
  end

  def pictures_without_report
    pictures.where(report_id: nil)
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(email: data['email'])
    end
    user
  end
end

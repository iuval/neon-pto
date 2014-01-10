class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, uniqueness: true

  has_many :pictures
  has_many :reports
  has_many :user_love_reports
  validate :email_is_neonroots

  def email_is_neonroots
    unless !!(email =~ /^.+@#{ENV['neonroots_host']}/)
      errors[:email] << I18n.t('auth.non_neonroots')
    end
  end

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

  def toggle_love(report)
    love = user_love_reports.where(report_id: report).first
    love_count = this_month_love_count
    if love
      love.destroy
      love_count -= 1
    else
      if love_count < UserLoveReport.max_love_per_month
        user_love_reports.create(report: report)
        love_count += 1
      end
    end
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

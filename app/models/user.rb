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
    user_love_reports.where('extract(month from created_at) = ?', Date.today.month).sum(:value)
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

  def toggle_love(report, value)
    love = user_love_reports.where(report_id: report).first
    love_count = this_month_love_count
    init_love_count = love_count
    if love
      # if the value is the same, delete love
      # if it is diferent, update love
      if love.value == value
        love_count -= love.value
        love.destroy
      else
        if love_count - love.value + value <= UserLoveReport.max_love_per_month
          love_count = love_count - love.value + value
          love.value = value
          love.save
        end
      end
    else
      if love_count + value <= UserLoveReport.max_love_per_month
        love_count += value
        user_love_reports.create(report: report, value: value)
      end
    end
    { init: init_love_count, final: love_count  }
  end

  def love_for_report(report)
    love = user_love_reports.where(report_id: report).first
    if love
      love.value
    else
      -1
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

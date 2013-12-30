class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :pictures
  has_many :reports
  has_many :user_love_reports

  def this_month_love_count
    user_love_reports.where('extract(month from created_at) = ?', Date.today.month).count
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
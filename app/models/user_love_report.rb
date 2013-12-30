class UserLoveReport < ActiveRecord::Base
  @@MAX_LOVE_PER_MONTH = ENV['max_love_per_month'].to_i

  belongs_to :user
  belongs_to :report

  def self.max_love_per_month
    @@MAX_LOVE_PER_MONTH
  end
end

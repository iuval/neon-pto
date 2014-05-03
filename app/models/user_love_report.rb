class UserLoveReport < ActiveRecord::Base
  MAX_LOVE_PER_MONTH = ENV['max_love_per_month'].to_i

  belongs_to :user
  belongs_to :report

  validates_numericality_of :value, presence: true, greater_than: 0
end

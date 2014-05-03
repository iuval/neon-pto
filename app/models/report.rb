class Report < ActiveRecord::Base
  NEXT_MONTH_DAYS_TO_VOTE = ENV['next_month_days_to_vote'].to_i

  attr_accessor :date

  belongs_to :user
  has_many :pictures
  has_many :user_love_reports

  validates :user,  presence: true
  validates :title, presence: true
  validates :body,  presence: true
  validates :day,   presence: true
  validates :month, presence: true
  validates :year,  presence: true

  delegate :email, to: :user, prefix: true

  scope :published, -> { where(published: true) }

  def love
    user_love_reports.count
  end

  def can_vote?
    month == Date.today.month ||
      (month == Date.today.month - 1 && Date.today.day <= Report::NEXT_MONTH_DAYS_TO_VOTE)
  end

  def date
    if self.day == nil
      value      = Date.today
      self.day   = value.day
      self.month = value.month
      self.year  = value.year
    end
    "#{day}-#{month}-#{year}".to_date
  end

  def date=(value = Date.today)
    day   = value.day
    month = value.month
    year  = value = year
  end
end

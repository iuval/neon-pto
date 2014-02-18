class Report < ActiveRecord::Base
  @@MAX_CHARS = ENV['report_max_chars'].to_i
  @@NEXT_MONTH_DAYS_TO_VOTE = ENV['next_month_days_to_vote'].to_i

  belongs_to :user
  has_many :pictures
  has_many :user_love_reports

  validates :user, presence: :true
  validates :title, presence: :true
  validates :body, presence: true, length: { maximum: @@MAX_CHARS }
  validates :date, presence: true

  delegate :email, to: :user, prefix: true

  scope :published, -> { where(published: true) }

  def self.max_chars
    @@MAX_CHARS
  end

  def self.next_month_days_to_vote
    @@NEXT_MONTH_DAYS_TO_VOTE
  end

  def love
    user_love_reports.count
  end
end

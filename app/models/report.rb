class Report < ActiveRecord::Base
  @@max_chars = ENV['report_max_chars'].to_i

  belongs_to :user
  has_many :pictures
  has_many :user_love_reports

  validates :title, presence: :true
  validates :body, presence: true, length: { maximum: @@max_chars }
  validates :date, presence: true

  def self.max_chars
    @@max_chars
  end

  def love
    user_love_reports.where('extract(month from created_at) = ?', Date.today.month).count
  end
end

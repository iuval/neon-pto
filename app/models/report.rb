class Report < ActiveRecord::Base
  @@max_chars = ENV['report_max_chars'].to_i

  belongs_to :user
  has_many :pictures

  validates :title, presence: :true
  validates :body, presence: true, length: { maximum: @@max_chars }
  validates :date, presence: true

  def self.max_chars
    @@max_chars
  end
end

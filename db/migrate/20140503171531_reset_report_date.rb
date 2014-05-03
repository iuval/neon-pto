class ResetReportDate < ActiveRecord::Migration
  def change
    Report.all.each do |report|
      date = report.created_at

      report.day   = date.day
      report.month = date.month
      report.year  = date.year

      report.save
    end
  end
end

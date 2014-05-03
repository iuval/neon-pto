class SeparateDate < ActiveRecord::Migration
  def change
    add_column :reports, :day,   :integer
    add_column :reports, :month, :integer
    add_column :reports, :year,  :integer

    Report.all.each do |report|
      date = report.date

      report.day   = date.day
      report.month = date.month
      report.year  = date.year

      report.save
    end

    remove_column :reports, :date
  end
end

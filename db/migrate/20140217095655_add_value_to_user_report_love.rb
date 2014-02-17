class AddValueToUserReportLove < ActiveRecord::Migration
  def change
    add_column :user_love_reports, :value, :integer, default: 1
  end
end

class ChangeLoveReportsIndex < ActiveRecord::Migration
  def change
    remove_index :user_love_reports, :user_id
    remove_index :user_love_reports, :report_id

    add_index :user_love_reports, [:user_id, :report_id], unique: true
  end
end

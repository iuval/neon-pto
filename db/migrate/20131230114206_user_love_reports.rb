class UserLoveReports < ActiveRecord::Migration
  def change
    create_table :user_love_reports do |t|
      t.references :user
      t.references :report

      t.timestamps
    end
  end
end

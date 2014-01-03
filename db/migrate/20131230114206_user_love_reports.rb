class UserLoveReports < ActiveRecord::Migration
  def change
    create_table :user_love_reports do |t|
      t.references :user
      t.references :report

      t.timestamps
    end
    add_index :user_love_reports, :user_id,   unique: true
    add_index :user_love_reports, :report_id, unique: true
  end
end

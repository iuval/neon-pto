class CreatePicturesReports < ActiveRecord::Migration
  def change
    create_table :pictures_reports do |t|
      t.references :picture
      t.references :report

      t.timestamps
    end
  end
end

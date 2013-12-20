class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user, index: true
      t.text :body
      t.string :title
      t.date :date

      t.timestamps
    end
  end
end
